import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/utils/routes/route_generator.dart';
import '../../res/constants/app_constants.dart';
import '../../utils/helpers/common_functions.dart';
import '../../utils/routes/route_constants.dart';
import 'network_base_services.dart';
import '../../services/connectivity_service.dart';
import '../../services/token_service.dart';

part 'network_services.g.dart';

@Riverpod(keepAlive: true)
NetworkServices networkServices(Ref<NetworkServices> ref) {
  return NetworkServices(ref);
}

/// Maximum characters to log from a response body.
/// Prevents jank/OOM when debugging endpoints that return huge payloads.
const int _kMaxLogBodyLength = 2000;

/// Pretty-prints JSON and truncates to [_kMaxLogBodyLength] characters.
String _formatBody(dynamic data) {
  try {
    final encoded = const JsonEncoder.withIndent('  ').convert(data);
    if (encoded.length > _kMaxLogBodyLength) {
      return '${encoded.substring(0, _kMaxLogBodyLength)}\n  …[truncated ${encoded.length - _kMaxLogBodyLength} chars]';
    }
    return encoded;
  } catch (_) {
    final fallback = data.toString();
    if (fallback.length > _kMaxLogBodyLength) {
      return '${fallback.substring(0, _kMaxLogBodyLength)}\n  …[truncated]';
    }
    return fallback;
  }
}

/// Masks a Bearer token to only show the last 6 chars.
String _maskToken(String? token) {
  if (token == null || token.isEmpty) return '[none]';
  if (token.length <= 10) return '•••';
  return 'Bearer •••${token.substring(token.length - 6)}';
}

class NetworkServices extends NetWorkBaseServices {
  static const kConnectTimeOut = Duration(milliseconds: 60000);
  static const kReceiveTimeOut = Duration(milliseconds: 60000);

  late final Dio _dio;
  final Ref _ref;

  /// Completer-based token refresh — prevents race conditions when multiple
  /// 401s arrive concurrently. All concurrent callers await the same future.
  Completer<bool>? _refreshCompleter;

  NetworkServices(this._ref) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseURL,
        connectTimeout: kConnectTimeOut,
        receiveTimeout: kReceiveTimeOut,
        receiveDataWhenStatusError: true,
        headers: {"Content-Type": "application/json"},
      ),
    );

    // ── Auth Interceptor ─────────────────────────────────────────────────
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final isFromAuth = options.extra['isFromAuth'] ?? false;
          final token = await _ref.read(tokenServiceProvider).getAccessToken();

          if (!isFromAuth && token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            final isFromAuth = e.requestOptions.extra['isFromAuth'] ?? false;
            if (!isFromAuth) {
              final refreshed = await _ensureTokenRefreshed();

              if (refreshed) {
                final token = await _ref
                    .read(tokenServiceProvider)
                    .getAccessToken();
                e.requestOptions.headers["Authorization"] = "Bearer $token";
                return handler.resolve(await _retry(e.requestOptions));
              } else {
                _logout();
              }
            }
          }
          return handler.next(e);
        },
      ),
    );

    // ── Logging Interceptor (debug builds only) ──────────────────────────
    if (kDebugMode) {
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            options.extra['_requestStartTime'] =
                DateTime.now().millisecondsSinceEpoch;

            debugPrint(
              '┌─ 🌐 ${options.method} ${options.baseUrl}${options.path}',
            );
            debugPrint(
              '│  🔒 Token: ${_maskToken(options.headers["Authorization"]?.toString())}',
            );
            if (options.queryParameters.isNotEmpty) {
              debugPrint('│  📎 Params: ${options.queryParameters}');
            }
            if (options.data != null) {
              if (options.data is FormData) {
                debugPrint('│  📦 Body (FormData):');
                for (final field in (options.data as FormData).fields) {
                  debugPrint('│    ${field.key} = ${field.value}');
                }
              } else {
                debugPrint('│  📦 Body:\n${_formatBody(options.data)}');
              }
            }
            debugPrint('└─');
            return handler.next(options);
          },
          onResponse: (response, handler) {
            final duration = _requestDuration(response.requestOptions);
            debugPrint(
              '┌─ ✅ ${response.statusCode} ${response.requestOptions.method} '
              '${response.requestOptions.path} — ${duration}ms',
            );
            debugPrint('│  📋 Data:\n${_formatBody(response.data)}');
            debugPrint('└─');
            return handler.next(response);
          },
          onError: (DioException e, handler) {
            final duration = _requestDuration(e.requestOptions);
            debugPrint(
              '┌─ ❌ ${e.response?.statusCode ?? "?"} ${e.requestOptions.method} '
              '${e.requestOptions.path} — ${duration}ms',
            );
            if (e.response?.data != null) {
              debugPrint('│  📉 Error:\n${_formatBody(e.response?.data)}');
            }
            debugPrint('└─');
            return handler.next(e);
          },
        ),
      );
    }
  }

  // ── Token Refresh (Completer-based, race-safe) ─────────────────────────

  /// Ensures only one refresh call is in-flight. All concurrent 401 handlers
  /// await the same [Completer] future.
  Future<bool> _ensureTokenRefreshed() async {
    if (_refreshCompleter != null) {
      // Another call is already refreshing — wait for its result.
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<bool>();
    try {
      final success = await getAccessTokenWithRefreshToken();
      _refreshCompleter!.complete(success);
      return success;
    } catch (e) {
      _refreshCompleter!.complete(false);
      return false;
    } finally {
      _refreshCompleter = null;
    }
  }

  /// Calculates request duration from the timestamp stored in extras.
  int _requestDuration(RequestOptions options) {
    final start = options.extra['_requestStartTime'] as int?;
    if (start == null) return -1;
    return DateTime.now().millisecondsSinceEpoch - start;
  }

  Future<Response> _retry(RequestOptions requestOptions) {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
      extra: requestOptions.extra,
    );
    return _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  // ── Internet Check (singleton Connectivity) ────────────────────────────

  Future<void> _assertInternetAvailable() async {
    final isConnected = _ref.read(connectivityServiceProvider).isConnected;
    if (!isConnected) {
      debugPrint('🔴 No internet connection (cached check)');
      throw ApiExceptions.noInternet();
    }
  }

  // ── Unified Request Executor ───────────────────────────────────────────

  /// Central method that all HTTP verb helpers delegate to.
  /// Eliminates the boilerplate of repeating internet-check → try/catch →
  /// BaseResponse mapping in every single verb method.
  Future<BaseResponse> _executeRequest({
    required String method,
    required String endPoint,
    dynamic parameters,
    Map<String, dynamic>? queryParameters,
    bool isFromAuth = false,
  }) async {
    await _assertInternetAvailable();

    try {
      final Response response = await _dio.request(
        endPoint,
        data: parameters,
        queryParameters: queryParameters,
        options: Options(method: method, extra: {'isFromAuth': isFromAuth}),
      );
      return BaseResponse(statusCode: response.statusCode, data: response.data);
    } on DioException catch (error) {
      return BaseResponse(
        statusCode: error.response?.statusCode,
        data: error.response?.data,
      );
    } catch (e) {
      debugPrint('🔴 Unexpected Error in $method $endPoint: $e');
      throw ApiExceptions.oops();
    }
  }

  // ── Public HTTP Methods ────────────────────────────────────────────────

  @override
  Future<BaseResponse> getRequest({
    required String endPoint,
    Map<String, dynamic>? parameters,
    Map<String, dynamic>? queryParameters,
    bool isFromAuth = false,
  }) => _executeRequest(
    method: 'GET',
    endPoint: endPoint,
    parameters: parameters,
    queryParameters: queryParameters,
    isFromAuth: isFromAuth,
  );

  @override
  Future<BaseResponse> postRequest({
    required String endPoint,
    Map<String, dynamic>? parameters,
    Map<String, dynamic>? queryParameters,
    bool isFromAuth = false,
  }) => _executeRequest(
    method: 'POST',
    endPoint: endPoint,
    parameters: parameters,
    queryParameters: queryParameters,
    isFromAuth: isFromAuth,
  );

  @override
  Future<BaseResponse> putRequest({
    required String endPoint,
    Map<String, dynamic>? parameters,
    Map<String, dynamic>? queryParameters,
    bool isFromAuth = false,
  }) => _executeRequest(
    method: 'PUT',
    endPoint: endPoint,
    parameters: parameters,
    queryParameters: queryParameters,
    isFromAuth: isFromAuth,
  );

  @override
  Future<BaseResponse> patchRequest({
    required String endPoint,
    dynamic parameters,
    Map<String, dynamic>? queryParameters,
    bool isFromAuth = false,
  }) => _executeRequest(
    method: 'PATCH',
    endPoint: endPoint,
    parameters: parameters,
    queryParameters: queryParameters,
    isFromAuth: isFromAuth,
  );

  @override
  Future<BaseResponse> deleteRequest({
    required String endPoint,
    Map<String, dynamic>? parameters,
    Map<String, dynamic>? queryParameters,
    bool isFromAuth = false,
  }) => _executeRequest(
    method: 'DELETE',
    endPoint: endPoint,
    parameters: parameters,
    queryParameters: queryParameters,
    isFromAuth: isFromAuth,
  );

  @override
  Future<BaseResponse> downloadRequest({
    required String endPoint,
    Map<String, dynamic>? parameters,
    bool isFromAuth = false,
  }) => _executeRequest(
    method: 'POST',
    endPoint: endPoint,
    parameters: parameters,
    isFromAuth: isFromAuth,
  );

  // ── Specialised Requests (can't fully delegate to _executeRequest) ─────

  @override
  Future<BaseResponse> multiPartRequest({
    required String endPoint,
    required FormData formFields,
    Function(int, int)? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    await _assertInternetAvailable();

    try {
      final Response response = await _dio.post(
        endPoint,
        data: formFields,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
      return BaseResponse(statusCode: response.statusCode, data: response.data);
    } on DioException catch (error) {
      return BaseResponse(
        statusCode: error.response?.statusCode,
        data: error.response?.data,
      );
    } catch (e) {
      debugPrint('🔴 Unexpected Error in multiPartRequest: $e');
      throw ApiExceptions.oops();
    }
  }

  @override
  Future<BaseResponse> postFile({
    required String endPoint,
    required FormData formFields,
    required void Function(int, int)? onSendProgress,
    bool isFromAuth = false,
  }) async {
    await _assertInternetAvailable();

    try {
      final Response response = await _dio.post(
        endPoint,
        data: formFields,
        onSendProgress: (sent, total) {
          if (kDebugMode) {
            debugPrint(
              '📊 Upload Progress: ${((sent / total) * 100).toStringAsFixed(0)}%',
            );
          }
          onSendProgress?.call(sent, total);
        },
        options: Options(extra: {'isFromAuth': isFromAuth}),
      );
      return BaseResponse(statusCode: response.statusCode, data: response.data);
    } on DioException catch (error) {
      return BaseResponse(
        statusCode: error.response?.statusCode,
        data: error.response?.data,
      );
    } catch (e) {
      debugPrint('🔴 Unexpected Error in postFile: $e');
      throw ApiExceptions.oops();
    }
  }

  @override
  Future<BaseResponse> getRequestWithUrl({required String url}) async {
    await _assertInternetAvailable();

    try {
      // Use the shared Dio so interceptors (logging, etc.) still fire.
      final Response response = await _dio.get(
        url,
        options: Options(extra: {'isFromAuth': true}),
      );
      return BaseResponse(statusCode: response.statusCode, data: response.data);
    } on DioException catch (error) {
      return BaseResponse(
        statusCode: error.response?.statusCode,
        data: error.response?.data,
      );
    } catch (e) {
      debugPrint('🔴 Unexpected Error in getRequestWithUrl: $e');
      throw ApiExceptions.oops();
    }
  }

  @override
  Future<BaseResponse> downloadFile({
    required String endPoint,
    required String savePath,
    Map<String, dynamic>? queryParameters,
    bool isFromAuth = false,
  }) async {
    await _assertInternetAvailable();

    try {
      final Response response = await _dio.download(
        endPoint,
        savePath,
        queryParameters: queryParameters,
        options: Options(extra: {'isFromAuth': isFromAuth}),
      );
      return BaseResponse(statusCode: response.statusCode, data: response.data);
    } on DioException catch (error) {
      return BaseResponse(
        statusCode: error.response?.statusCode,
        data: error.response?.data,
      );
    } catch (e) {
      debugPrint('🔴 Unexpected Error in downloadFile: $e');
      throw ApiExceptions.oops();
    }
  }

  // ── Status & Parsing ───────────────────────────────────────────────────

  @override
  Either<ResponseError, BaseResponse> checkHttpStatus(BaseResponse response) {
    return getStatus(response);
  }

  @override
  Either<ResponseError, BaseResponse> getStatus(BaseResponse response) {
    return switch (response.statusCode) {
      200 || 201 || 204 => Right(response),
      401 || 403 => Left(
        ResponseError(
          key: ApiErrorTypes.unAuthorized,
          message: "UnAuthorized",
          response: response.data,
        ),
      ),
      404 => Left(
        ResponseError(
          key: ApiErrorTypes.notFound,
          message: "Not Found",
          response: response.data,
        ),
      ),
      422 => Left(
        ResponseError(
          key: ApiErrorTypes.badRequest,
          message: "Validation Error",
          response: response.data,
        ),
      ),
      429 => Left(
        ResponseError(
          key: ApiErrorTypes.serviceUnavailable,
          message: "Too Many Requests",
          response: response.data,
        ),
      ),
      500 => Left(
        ResponseError(
          key: ApiErrorTypes.internalServerError,
          message: "Internal Server Error",
          response: response.data,
        ),
      ),
      502 || 503 || 504 => Left(
        ResponseError(
          key: ApiErrorTypes.serviceUnavailable,
          message: "Service Unavailable",
          response: response.data,
        ),
      ),
      _ => Left(
        ResponseError(
          key: ApiErrorTypes.unknown,
          message: "Unknown",
          response: response.data,
        ),
      ),
    };
  }

  @override
  Future<Either<ResponseError, dynamic>> parseJson(
    BaseResponse response,
  ) async {
    try {
      return Right(response.data);
    } catch (e) {
      return const Left(
        ResponseError(
          key: ApiErrorTypes.jsonParsing,
          message: "Failed on json Parsing",
        ),
      );
    }
  }

  @override
  Future<Either<ResponseError, BaseResponse>> safe(
    Future<BaseResponse> request,
  ) async {
    try {
      return Right(await request);
    } on ApiExceptions catch (error) {
      return Left(
        ResponseError(
          key: error.errorType,
          message: error.message,
          response: error.response,
        ),
      );
    } catch (e) {
      return Left(
        ResponseError(
          key: ApiErrorTypes.unknown,
          message: "Unknown Error : $e",
        ),
      );
    }
  }

  // ── Auth Helpers ───────────────────────────────────────────────────────

  Future<void> _logout() async {
    debugPrint('🔴 Failed to refresh token — forcing logout');
    await _ref.read(tokenServiceProvider).clearTokens();

    if (navigatorKey.currentState != null) {
      executeAfterFrame(() {
        Navigator.pushNamedAndRemoveUntil(
          navigatorKey.currentState!.context,
          RouteConstants.routeLoginScreen,
          (_) => false,
        );
      });
    }
  }

  @override
  Future<bool> getAccessTokenWithRefreshToken() async {
    try {
      debugPrint('🔄 Refreshing access token…');
      final refreshToken = await _ref
          .read(tokenServiceProvider)
          .getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        debugPrint('🔴 No refresh token available in secure storage');
        return false;
      }
      final response = await postRequest(
        endPoint: AppConstants.refreshTokenApi,
        parameters: {'refresh': refreshToken},
        isFromAuth: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('🟢 Access token refreshed');
        final newAccessToken = response.data['access'] ?? '';
        await _ref
            .read(tokenServiceProvider)
            .saveTokens(
              accessToken: newAccessToken,
              refreshToken: refreshToken,
            );
        return true;
      } else {
        debugPrint('🔴 Refresh failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('🔴 Unexpected error during refresh: $e');
      return false;
    }
  }
}

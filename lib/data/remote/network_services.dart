import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/src/root/tsuite_app.dart';
import '../../res/constants/app_constants.dart';
import '../../utils/helpers/common_functions.dart';
import '../../utils/helpers/network_logger.dart';
import '../../utils/routes/route_constants.dart';
import 'network_base_services.dart';
import '../../services/auth_session_service.dart';
import '../../services/connectivity_service.dart';

part 'network_services.g.dart';

@Riverpod(keepAlive: true)
NetworkServices networkServices(Ref<NetworkServices> ref) {
  return NetworkServices(ref);
}

class NetworkServices extends NetWorkBaseServices {
  static const kConnectTimeOut = Duration(milliseconds: 60000);
  static const kReceiveTimeOut = Duration(milliseconds: 60000);

  late final Dio _dio;
  final Ref _ref;

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
          final token = AppConstants.accessToken;

          if (!isFromAuth && token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            final isFromAuth = e.requestOptions.extra['isFromAuth'] ?? false;
            if (!isFromAuth) {
              await _forceLogout();
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

            NetworkLogger.request(
              method: options.method,
              url: '${options.baseUrl}${options.path}',
              token: options.headers['Authorization']?.toString(),
              queryParameters: options.queryParameters.isEmpty
                  ? null
                  : options.queryParameters,
              body: options.data,
            );
            return handler.next(options);
          },
          onResponse: (response, handler) {
            NetworkLogger.response(
              statusCode: response.statusCode,
              method: response.requestOptions.method,
              path: response.requestOptions.path,
              durationMs: _requestDuration(response.requestOptions),
              data: response.data,
            );
            return handler.next(response);
          },
          onError: (DioException e, handler) {
            NetworkLogger.error(
              statusCode: e.response?.statusCode,
              method: e.requestOptions.method,
              path: e.requestOptions.path,
              durationMs: _requestDuration(e.requestOptions),
              data: e.response?.data,
              message: e.message,
            );
            return handler.next(e);
          },
        ),
      );
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────────────

  /// Calculates request duration from the timestamp stored in extras.
  int _requestDuration(RequestOptions options) {
    final start = options.extra['_requestStartTime'] as int?;
    if (start == null) return -1;
    return DateTime.now().millisecondsSinceEpoch - start;
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

  Future<void> _forceLogout() async {
    debugPrint('🔴 401 UNAUTHORIZED — clearing session and forcing logout');
    await _ref.read(authSessionServiceProvider).clear();

    final navKey = _ref.read(navigatorKeyProvider);
    if (navKey.currentState != null) {
      executeAfterFrame(() {
        Navigator.pushNamedAndRemoveUntil(
          navKey.currentState!.context,
          RouteConstants.routeLoginScreen,
          (_) => false,
        );
      });
    }
  }

  @override
  Future<bool> getAccessTokenWithRefreshToken() async {
    // No refresh endpoint — always force re-login on expiry.
    debugPrint('🟡 Token refresh not supported; session must be re-authenticated');
    return false;
  }
}

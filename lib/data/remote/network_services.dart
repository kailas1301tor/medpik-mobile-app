import 'dart:async';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/src/root/medpik_app.dart';
import '../../res/constants/app_constants.dart';
import '../../utils/helpers/common_functions.dart';
import '../../utils/helpers/api_error_handler.dart';
import '../../utils/helpers/network_logger.dart';
import '../../utils/routes/route_constants.dart';
import 'network_base_services.dart';
import '../../services/connectivity_service.dart';
import '../../src/auth/notifier/auth_notifier.dart';

part 'network_services.g.dart';

@Riverpod(keepAlive: true)
NetworkServices networkServices(Ref<NetworkServices> ref) {
  return NetworkServices(ref);
}

class NetworkServices extends NetWorkBaseServices {
  static const kConnectTimeOut = Duration(milliseconds: 60000);
  static const kReceiveTimeOut = Duration(milliseconds: 60000);
  static const _sessionEndedMessage = 'Session ended';

  late final Dio _dio;
  final Ref _ref;
  CancelToken _sessionCancelToken = CancelToken();
  bool _sessionGuardInProgress = false;
  /// Sticky until a valid session is observed again — prevents
  /// invalidate → keepAlive rebuild → fetch → sessionRequired loops.
  bool _sessionRequiredHandled = false;

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

          if (!isFromAuth && !AppConstants.hasSession) {
            return handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.cancel,
                message: _sessionEndedMessage,
              ),
            );
          }

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

  /// Cancels all in-flight session requests and resets the shared cancel token.
  /// Call before clearing session tokens on logout / unauthorized handling.
  Future<void> cancelPendingRequests({
    String reason = _sessionEndedMessage,
  }) async {
    if (!_sessionCancelToken.isCancelled) {
      _sessionCancelToken.cancel(reason);
    }
    _sessionCancelToken = CancelToken();
    debugPrint('🟡 NETWORK: cancelled pending requests — $reason');
  }

  CancelToken _resolveCancelToken(CancelToken? override) =>
      override ?? _sessionCancelToken;

  /// Calculates request duration from the timestamp stored in extras.
  int _requestDuration(RequestOptions options) {
    final start = options.extra['_requestStartTime'] as int?;
    if (start == null) return -1;
    return DateTime.now().millisecondsSinceEpoch - start;
  }

  void _assertSession({bool isFromAuth = false}) {
    if (AppConstants.hasSession) {
      _sessionRequiredHandled = false;
    }
    if (!isFromAuth && !AppConstants.hasSession) {
      throw ApiExceptions(
        message: _sessionEndedMessage,
        errorType: ApiErrorTypes.sessionRequired,
      );
    }
  }

  void _rethrowSessionDioException(DioException error) {
    if (error.type == DioExceptionType.cancel &&
        error.message == _sessionEndedMessage) {
      throw ApiExceptions(
        message: _sessionEndedMessage,
        errorType: ApiErrorTypes.sessionRequired,
      );
    }
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
    _assertSession(isFromAuth: isFromAuth);

    await _assertInternetAvailable();

    try {
      final Response response = await _dio.request(
        endPoint,
        data: parameters,
        queryParameters: queryParameters,
        cancelToken: _sessionCancelToken,
        options: Options(method: method, extra: {'isFromAuth': isFromAuth}),
      );
      return BaseResponse(statusCode: response.statusCode, data: response.data);
    } on DioException catch (error) {
      _rethrowSessionDioException(error);
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
    _assertSession();
    await _assertInternetAvailable();

    try {
      final Response response = await _dio.post(
        endPoint,
        data: formFields,
        onSendProgress: onSendProgress,
        cancelToken: _resolveCancelToken(cancelToken),
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
    _assertSession(isFromAuth: isFromAuth);
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
        cancelToken: _sessionCancelToken,
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
        cancelToken: _sessionCancelToken,
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

  Future<List<int>> getBytesWithUrl({required String url}) async {
    await _assertInternetAvailable();

    try {
      final response = await _dio.get<List<int>>(
        url,
        cancelToken: _sessionCancelToken,
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = response.data;
      if (response.statusCode != 200 || bytes == null || bytes.isEmpty) {
        throw ApiExceptions.oops();
      }
      return bytes;
    } on DioException catch (error) {
      debugPrint('🔴 PDF download error: ${error.message}');
      throw ApiExceptions.oops();
    } catch (e) {
      debugPrint('🔴 Unexpected Error in getBytesWithUrl: $e');
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
        cancelToken: _sessionCancelToken,
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
    final result = _resolveHttpStatus(response);
    result.fold(
      (error) => _logResponseError(error, statusCode: response.statusCode),
      (_) {},
    );
    return result;
  }

  Either<ResponseError, BaseResponse> _resolveHttpStatus(
    BaseResponse response,
  ) {
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
          message: extractApiErrorMessage(response.data) ?? "Not Found",
          response: response.data,
        ),
      ),
      400 => Left(
        ResponseError(
          key: ApiErrorTypes.badRequest,
          message: extractApiErrorMessage(response.data) ?? "Bad Request",
          response: response.data,
        ),
      ),
      422 => Left(
        ResponseError(
          key: ApiErrorTypes.badRequest,
          message: extractApiErrorMessage(response.data) ?? "Validation Error",
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
          message: extractApiErrorMessage(response.data) ?? "Unknown",
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
      const error = ResponseError(
        key: ApiErrorTypes.jsonParsing,
        message: "Failed on json Parsing",
      );
      _logResponseError(error);
      return const Left(error);
    }
  }

  void _logResponseError(ResponseError error, {int? statusCode}) {
    if (isSessionRequired(error)) return;
    final statusSuffix = statusCode != null ? ' ($statusCode)' : '';
    debugPrint('🔴 API ERROR$statusSuffix: [${error.key}] ${error.message}');
  }

  void _logUnexpectedApiError(Object error) {
    debugPrint('🔴 API UNEXPECTED ERROR: $error');
  }

  @override
  Future<Either<ResponseError, BaseResponse>> safe(
    Future<BaseResponse> request,
  ) async {
    try {
      return Right(await request);
    } on ApiExceptions catch (error) {
      if (error.errorType == ApiErrorTypes.sessionRequired) {
        unawaited(_handleSessionRequired());
      } else {
        _logResponseError(
          ResponseError(
            key: error.errorType,
            message: error.message,
            response: error.response,
          ),
        );
      }
      return Left(
        ResponseError(
          key: error.errorType,
          message: error.message,
          response: error.response,
        ),
      );
    } catch (e) {
      _logUnexpectedApiError(e);
      return Left(
        ResponseError(
          key: ApiErrorTypes.unknown,
          message: "Unknown Error : $e",
        ),
      );
    }
  }

  // ── Auth Helpers ───────────────────────────────────────────────────────

  Future<void> _handleSessionRequired() async {
    if (_sessionGuardInProgress || _sessionRequiredHandled) {
      debugPrint('🟡 SESSION REQUIRED — already handled, skipping');
      return;
    }

    _sessionGuardInProgress = true;
    _sessionRequiredHandled = true;
    try {
      // Session is already missing for this error. Clearing + InvalidateDI
      // would rebuild keepAlive notifiers and re-fire fetches → infinite loop.
      // Only run full logout cleanup if tokens somehow still exist.
      if (AppConstants.hasSession) {
        debugPrint(
          '🟡 SESSION REQUIRED — clearing session and redirecting to login',
        );
        await cancelPendingRequests(reason: _sessionEndedMessage);
        await _ref
            .read(authNotifierProvider.notifier)
            .clearSessionOnUnauthorized();
      } else {
        debugPrint('🟡 SESSION REQUIRED — redirecting to login');
      }
      _navigateToLogin();
    } finally {
      _sessionGuardInProgress = false;
    }
  }

  void _navigateToLogin() {
    final navKey = _ref.read(navigatorKeyProvider);
    final navigator = navKey.currentState;
    if (navigator == null) return;

    executeAfterFrame(() {
      final context = navigator.context;
      final currentRoute = ModalRoute.of(context)?.settings.name;
      if (currentRoute == RouteConstants.routeLoginScreen) return;

      navigator.pushNamedAndRemoveUntil(
        RouteConstants.routeLoginScreen,
        (_) => false,
      );
    });
  }

  Future<void> _forceLogout() async {
    if (_sessionGuardInProgress || _sessionRequiredHandled) {
      debugPrint('🟡 401 UNAUTHORIZED — session guard already handled');
      return;
    }

    if (!AppConstants.hasSession) {
      debugPrint('🟡 401 UNAUTHORIZED — session already cleared, skipping');
      _sessionRequiredHandled = true;
      _navigateToLogin();
      return;
    }

    _sessionGuardInProgress = true;
    _sessionRequiredHandled = true;
    try {
      debugPrint('🔴 401 UNAUTHORIZED — clearing session and forcing logout');
      await cancelPendingRequests(reason: 'Unauthorized');
      await _ref
          .read(authNotifierProvider.notifier)
          .clearSessionOnUnauthorized();
      _navigateToLogin();
    } finally {
      _sessionGuardInProgress = false;
    }
  }

  @override
  Future<bool> getAccessTokenWithRefreshToken() async {
    // No refresh endpoint — always force re-login on expiry.
    debugPrint(
      '🟡 Token refresh not supported; session must be re-authenticated',
    );
    return false;
  }
}

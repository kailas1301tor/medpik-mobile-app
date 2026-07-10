import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/res/enums/enums.dart';

LoaderState handleResponseError(ApiErrorTypes errorType) {
  return switch (errorType) {
    ApiErrorTypes.noInternet => LoaderState.networkError,
    ApiErrorTypes.internalServerError => LoaderState.serverError,
    ApiErrorTypes.serviceUnavailable => LoaderState.serverError,
    ApiErrorTypes.cancel => LoaderState.error,
    ApiErrorTypes.badCertificate => LoaderState.error,
    ApiErrorTypes.badResponse => LoaderState.error,
    ApiErrorTypes.connectionError => LoaderState.error,
    ApiErrorTypes.connectionTimeout => LoaderState.error,
    ApiErrorTypes.badRequest => LoaderState.error,
    ApiErrorTypes.jsonParsing => LoaderState.error,
    ApiErrorTypes.sendTimeout => LoaderState.error,
    ApiErrorTypes.notFound => LoaderState.error,
    ApiErrorTypes.oops => LoaderState.error,
    ApiErrorTypes.unAuthorized => LoaderState.error,
    ApiErrorTypes.receiveTimeout => LoaderState.error,
    _ => LoaderState.error,
  };
}

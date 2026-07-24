import 'package:medpik/data/remote/network_base_services.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';

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

/// Reads a user-facing message from API error payloads such as
/// `{ "message": "Invalid OTP.", "errors": {} }`.
String? extractApiErrorMessage(dynamic response) {
  if (response == null) return null;

  if (response is Map) {
    final message = convertToString(response['message']).trim();
    if (message.isNotEmpty) return message;

    final errors = response['errors'];
    if (errors is Map) {
      for (final entry in errors.entries) {
        final value = entry.value;
        if (value is List && value.isNotEmpty) {
          final first = convertToString(value.first).trim();
          if (first.isNotEmpty) return first;
        }
        final text = convertToString(value).trim();
        if (text.isNotEmpty) return text;
      }
    }
    return null;
  }

  if (response is String) {
    final text = response.trim();
    return text.isNotEmpty ? text : null;
  }

  return null;
}

String resolveApiErrorMessage({
  required ResponseError error,
  String? fallback,
}) {
  final direct = error.message?.trim();
  if (direct != null && direct.isNotEmpty && direct != 'Unknown') {
    return direct;
  }
  return extractApiErrorMessage(error.response) ??
      fallback ??
      'Something went wrong';
}

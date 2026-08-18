import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/data/remote/network_base_services.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/utils/helpers/api_error_handler.dart';

void main() {
  group('isSessionRequiredError', () {
    test('returns true for sessionRequired', () {
      expect(isSessionRequiredError(ApiErrorTypes.sessionRequired), isTrue);
    });

    test('returns false for other error types', () {
      expect(isSessionRequiredError(ApiErrorTypes.cancel), isFalse);
      expect(isSessionRequiredError(ApiErrorTypes.unAuthorized), isFalse);
    });
  });

  group('isSessionRequired', () {
    test('returns true when ResponseError key is sessionRequired', () {
      const error = ResponseError(
        key: ApiErrorTypes.sessionRequired,
        message: 'Session ended',
      );
      expect(isSessionRequired(error), isTrue);
    });

    test('returns false for other ResponseError keys', () {
      const error = ResponseError(
        key: ApiErrorTypes.badRequest,
        message: 'Bad request',
      );
      expect(isSessionRequired(error), isFalse);
    });
  });

  group('loaderStateForSessionAwareError', () {
    test('maps sessionRequired to noData', () {
      expect(
        loaderStateForSessionAwareError(ApiErrorTypes.sessionRequired),
        LoaderState.noData,
      );
    });

    test('delegates other errors to handleResponseError', () {
      expect(
        loaderStateForSessionAwareError(ApiErrorTypes.noInternet),
        LoaderState.networkError,
      );
      expect(
        loaderStateForSessionAwareError(ApiErrorTypes.cancel),
        LoaderState.error,
      );
    });
  });

  group('shouldReportFetchError', () {
    test('returns false for sessionRequired', () {
      const error = ResponseError(
        key: ApiErrorTypes.sessionRequired,
        message: 'Session ended',
      );
      expect(shouldReportFetchError(error), isFalse);
    });

    test('returns true for other errors', () {
      const error = ResponseError(
        key: ApiErrorTypes.badRequest,
        message: 'Bad request',
      );
      expect(shouldReportFetchError(error), isTrue);
    });
  });
}

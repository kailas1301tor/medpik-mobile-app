import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/utils/helpers/connectivity_result_helper.dart';

void main() {
  group('isOnlineFromConnectivityResults', () {
    test('empty results are offline', () {
      expect(isOnlineFromConnectivityResults(const []), isFalse);
    });

    test('none-only results are offline', () {
      expect(
        isOnlineFromConnectivityResults(const [ConnectivityResult.none]),
        isFalse,
      );
    });

    test('wifi is online', () {
      expect(
        isOnlineFromConnectivityResults(const [ConnectivityResult.wifi]),
        isTrue,
      );
    });

    test('mobile is online', () {
      expect(
        isOnlineFromConnectivityResults(const [ConnectivityResult.mobile]),
        isTrue,
      );
    });

    test('any non-none interface is online', () {
      expect(
        isOnlineFromConnectivityResults(const [
          ConnectivityResult.none,
          ConnectivityResult.wifi,
        ]),
        isTrue,
      );
    });
  });
}

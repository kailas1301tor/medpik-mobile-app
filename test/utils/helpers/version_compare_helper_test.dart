import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/utils/helpers/version_compare_helper.dart';

void main() {
  group('isAppVersionBelowMinimum', () {
    test('empty minimum disables the gate', () {
      expect(
        isAppVersionBelowMinimum(current: '1.0.0', minimum: ''),
        isFalse,
      );
    });

    test('detects older patch versions', () {
      expect(
        isAppVersionBelowMinimum(current: '1.0.0', minimum: '1.0.1'),
        isTrue,
      );
    });

    test('allows equal or newer versions', () {
      expect(
        isAppVersionBelowMinimum(current: '1.2.0', minimum: '1.2.0'),
        isFalse,
      );
      expect(
        isAppVersionBelowMinimum(current: '1.2.1', minimum: '1.2.0'),
        isFalse,
      );
    });

    test('ignores build metadata suffix', () {
      expect(
        isAppVersionBelowMinimum(current: '1.0.0+3', minimum: '1.0.1'),
        isTrue,
      );
    });
  });
}

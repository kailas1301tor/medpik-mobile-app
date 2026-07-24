import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/utils/helpers/image_mem_cache_helper.dart';

void main() {
  group('ImageMemCacheHelper.dimension', () {
    test('scales logical size by device pixel ratio', () {
      expect(
        ImageMemCacheHelper.dimension(56, 3),
        168,
      );
    });

    test('clamps to max', () {
      expect(
        ImageMemCacheHelper.dimension(200, 3, max: 300),
        300,
      );
    });

    test('clamps to min', () {
      expect(
        ImageMemCacheHelper.dimension(10, 2, min: 48),
        48,
      );
    });

    test('returns max for non-finite logical size', () {
      expect(
        ImageMemCacheHelper.dimension(double.infinity, 2, max: 300),
        300,
      );
    });
  });

  group('ImageMemCacheHelper.resolve', () {
    test('resolves width and height from finite logical sizes', () {
      final result = ImageMemCacheHelper.resolve(
        logicalWidth: 56,
        logicalHeight: 56,
        devicePixelRatio: 2,
      );

      expect(result.width, 112);
      expect(result.height, 112);
    });

    test('uses fallback width when logical width is infinite', () {
      final result = ImageMemCacheHelper.resolve(
        logicalWidth: double.infinity,
        logicalHeight: 118,
        devicePixelRatio: 2,
        fallbackLogicalWidth: 180,
        min: 150,
        max: 300,
      );

      expect(result.width, 300);
      expect(result.height, 236);
    });

    test('returns null dimensions when sizes are unavailable', () {
      final result = ImageMemCacheHelper.resolve(
        logicalWidth: double.infinity,
        logicalHeight: null,
        devicePixelRatio: 2,
      );

      expect(result.width, isNull);
      expect(result.height, isNull);
    });
  });
}

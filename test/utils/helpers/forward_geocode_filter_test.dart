// test/utils/helpers/forward_geocode_filter_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/utils/helpers/forward_geocode_filter.dart';

void main() {
  group('isUsefulForwardGeocodeResult', () {
    test('rejects country-only India hit', () {
      expect(
        isUsefulForwardGeocodeResult(
          types: const ['country', 'political'],
          latitude: 20.0,
          longitude: 77.0,
          state: '',
        ),
        isFalse,
      );
    });

    test('keeps Thrissur locality inside Kerala', () {
      expect(
        isUsefulForwardGeocodeResult(
          types: const ['locality', 'political'],
          latitude: 10.5276,
          longitude: 76.2144,
          state: 'Kerala',
        ),
        isTrue,
      );
    });

    test('keeps Kerala admin_area_level_1', () {
      expect(
        isUsefulForwardGeocodeResult(
          types: const ['administrative_area_level_1', 'political'],
          latitude: 10.5,
          longitude: 76.2,
          state: 'Kerala',
        ),
        isTrue,
      );
    });

    test('rejects out-of-bbox non-Kerala state', () {
      expect(
        isUsefulForwardGeocodeResult(
          types: const ['locality', 'political'],
          latitude: 28.6,
          longitude: 77.2,
          state: 'Delhi',
        ),
        isFalse,
      );
    });
  });

  group('isCoarseOnlyGeocodeTypes', () {
    test('country alone is coarse', () {
      expect(isCoarseOnlyGeocodeTypes(const ['country', 'political']), isTrue);
    });

    test('locality is not coarse', () {
      expect(
        isCoarseOnlyGeocodeTypes(const ['locality', 'political']),
        isFalse,
      );
    });
  });
}

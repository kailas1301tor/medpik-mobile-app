// test/utils/helpers/location_serviceability_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/services/location/haversine.dart';

void main() {
  group('shouldSkipReverseGeocodeApi', () {
    test('does not skip inside Kerala bounding box', () {
      expect(
        shouldSkipReverseGeocodeApi(latitude: 9.9312, longitude: 76.2673),
        isFalse,
      );
    });

    test('does not skip within delivery hub radius', () {
      expect(
        shouldSkipReverseGeocodeApi(latitude: 10.52, longitude: 76.21),
        isFalse,
      );
    });

    test('skips far outside Kerala and hub radius', () {
      expect(
        shouldSkipReverseGeocodeApi(latitude: 19.076, longitude: 72.8777),
        isTrue,
      );
    });
  });

  group('isWithinKeralaBoundingBox', () {
    test('Thrissur is inside Kerala bounds', () {
      expect(
        isWithinKeralaBoundingBox(latitude: 10.5241, longitude: 76.2121),
        isTrue,
      );
    });

    test('Mumbai is outside Kerala bounds', () {
      expect(
        isWithinKeralaBoundingBox(latitude: 19.076, longitude: 72.8777),
        isFalse,
      );
    });
  });
}

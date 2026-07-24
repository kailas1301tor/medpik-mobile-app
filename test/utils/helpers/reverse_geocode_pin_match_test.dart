// test/utils/helpers/reverse_geocode_pin_match_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/services/location/haversine.dart';

void main() {
  group('isReverseGeocodeMatchingPin', () {
    test('returns true when pin and result are at the same point', () {
      expect(
        isReverseGeocodeMatchingPin(
          pinLat: 10.5241,
          pinLng: 76.2121,
          resultLat: 10.5241,
          resultLng: 76.2121,
        ),
        isTrue,
      );
    });

    test('returns false when pin drift exceeds tolerance', () {
      expect(
        isReverseGeocodeMatchingPin(
          pinLat: 10.5241,
          pinLng: 76.2121,
          resultLat: 19.076,
          resultLng: 72.8777,
        ),
        isFalse,
      );
    });
  });
}

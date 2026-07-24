// test/utils/helpers/location_picker_confirm_helper_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/services/location/geocode_client.dart';
import 'package:medpik/utils/helpers/location_picker_confirm_helper.dart';

void main() {
  const reverse = ReverseGeocodeResult(
    latitude: 10.5241,
    longitude: 76.2121,
    formattedAddress: 'Thrissur, Kerala',
    state: 'Kerala',
  );

  group('canConfirmLocationPicker', () {
    test('returns true for matching serviceable pin', () {
      expect(
        canConfirmLocationPicker(
          isServiceable: true,
          isReverseLoading: false,
          errorMessage: null,
          reverseResult: reverse,
          pinLat: 10.5241,
          pinLng: 76.2121,
        ),
        isTrue,
      );
    });

    test('returns false when reverse geocode failed', () {
      expect(
        canConfirmLocationPicker(
          isServiceable: true,
          isReverseLoading: false,
          errorMessage: Strings.locationLookupFailed,
          reverseResult: reverse,
          pinLat: 10.5241,
          pinLng: 76.2121,
        ),
        isFalse,
      );
    });

    test('returns false when pin drift exceeds tolerance', () {
      expect(
        canConfirmLocationPicker(
          isServiceable: true,
          isReverseLoading: false,
          errorMessage: null,
          reverseResult: reverse,
          pinLat: 19.076,
          pinLng: 72.8777,
        ),
        isFalse,
      );
    });

    test('returns false while reverse geocode is loading', () {
      expect(
        canConfirmLocationPicker(
          isServiceable: true,
          isReverseLoading: true,
          errorMessage: null,
          reverseResult: reverse,
          pinLat: 10.5241,
          pinLng: 76.2121,
        ),
        isFalse,
      );
    });
  });
}

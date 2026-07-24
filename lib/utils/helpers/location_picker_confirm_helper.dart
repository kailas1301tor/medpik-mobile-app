// lib/utils/helpers/location_picker_confirm_helper.dart
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/services/location/geocode_client.dart';
import 'package:medpik/services/location/haversine.dart';

bool canConfirmLocationPicker({
  required bool isServiceable,
  required bool isReverseLoading,
  required String? errorMessage,
  required ReverseGeocodeResult? reverseResult,
  required double pinLat,
  required double pinLng,
}) {
  if (!isServiceable || isReverseLoading || reverseResult == null) {
    return false;
  }
  if (errorMessage == Strings.locationLookupFailed) return false;

  return isReverseGeocodeMatchingPin(
    pinLat: pinLat,
    pinLng: pinLng,
    resultLat: reverseResult.latitude,
    resultLng: reverseResult.longitude,
  );
}

// lib/src/address/model/location_picker_args.dart
//
// ? Route args when re-opening picker from AddressFormMapPickRow.
// ? With coordinates set, map seeds camera at existing pick instead of GPS.
class LocationPickerArgs {
  const LocationPickerArgs({
    this.initialLatitude,
    this.initialLongitude,
  });

  final double? initialLatitude;
  final double? initialLongitude;
}

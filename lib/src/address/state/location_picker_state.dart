// lib/src/address/state/location_picker_state.dart
//
// ? Immutable UI state for LocationPickerNotifier.
//
// ? Map / pin:
// ? - latitude / longitude — pin position (pan + geocode)
// ? - reverseResult — parsed lines from Google reverse geocode
//
// ? Loading:
// ? - isSearching → LocationSearchBar trailing spinner
// ? - isReverseLoading → LocationConfirmCard shimmer
//
// ? Validation:
// ? - isServiceable — within delivery area (LocationConfig)
// ? - errorMessage — pin / GPS / serviceability (bottom card)
// ? - searchErrorMessage — search errors (below search bar)
//
// ? confirmedPick — set when confirmSelection succeeds (debug/audit)
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/services/location/geocode_client.dart';
import 'package:medpik/services/location/location_config.dart';
import 'package:medpik/src/address/model/picked_location_model.dart';

part 'location_picker_state.freezed.dart';

@freezed
sealed class LocationPickerState with _$LocationPickerState {
  const factory LocationPickerState({
    @Default(LoaderState.loaded) LoaderState loaderState,
    @Default(LocationConfig.defaultLat) double latitude,
    @Default(LocationConfig.defaultLng) double longitude,
    ReverseGeocodeResult? reverseResult,
    @Default(false) bool isSearching,
    @Default(false) bool isReverseLoading,
    @Default(false) bool isServiceable,
    String? errorMessage,
    String? searchErrorMessage,
    PickedLocationModel? confirmedPick,
  }) = _LocationPickerState;
}

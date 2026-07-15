// lib/src/address/state/location_picker_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/services/location/geocode_client.dart';
import 'package:tsuite/services/location/location_config.dart';
import 'package:tsuite/services/location/places_session_client.dart';
import 'package:tsuite/src/address/model/picked_location_model.dart';

part 'location_picker_state.freezed.dart';

@freezed
sealed class LocationPickerState with _$LocationPickerState {
  const factory LocationPickerState({
    @Default(LoaderState.loaded) LoaderState loaderState,
    @Default(LocationConfig.defaultLat) double latitude,
    @Default(LocationConfig.defaultLng) double longitude,
    @Default([]) List<PlacePrediction> predictions,
    ReverseGeocodeResult? reverseResult,
    @Default(false) bool isSearching,
    @Default(false) bool isReverseLoading,
    @Default(false) bool isServiceable,
    String? errorMessage,
    PickedLocationModel? confirmedPick,
  }) = _LocationPickerState;
}

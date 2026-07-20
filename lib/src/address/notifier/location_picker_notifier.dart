// lib/src/address/notifier/location_picker_notifier.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/services/location/geocode_client.dart';
import 'package:tsuite/services/location/haversine.dart';
import 'package:tsuite/services/location/location_config.dart';
import 'package:tsuite/services/location/location_permission_service.dart';
import 'package:tsuite/services/location/places_session_client.dart';
import 'package:tsuite/src/address/model/picked_location_model.dart';
import 'package:tsuite/src/address/state/location_picker_state.dart';

part 'location_picker_notifier.g.dart';

@Riverpod(keepAlive: false)
class LocationPickerNotifier extends _$LocationPickerNotifier {
  late final TextEditingController searchController;
  late final PlacesSessionClient _places;
  late final GeocodeClient _geocode;
  late final LocationPermissionService _permission;

  GoogleMapController? mapController;
  Timer? _autocompleteTimer;
  Timer? _reverseTimer;
  double? _lastReverseLat;
  double? _lastReverseLng;
  bool _programmaticMove = false;
  bool _initialApplied = false;
  bool _disposed = false;
  int _autocompleteGeneration = 0;
  int _reverseGeneration = 0;
  LatLng? _pendingCameraTarget;
  double _cameraLat = LocationConfig.defaultLat;
  double _cameraLng = LocationConfig.defaultLng;

  @override
  LocationPickerState build() {
    searchController = TextEditingController();
    _places = ref.read(placesSessionClientProvider);
    _geocode = ref.read(geocodeClientProvider);
    _permission = const LocationPermissionService();
    _disposed = false;
    _cameraLat = LocationConfig.defaultLat;
    _cameraLng = LocationConfig.defaultLng;

    ref.onDispose(() {
      _disposed = true;
      _autocompleteTimer?.cancel();
      _reverseTimer?.cancel();
      searchController.dispose();
      mapController?.dispose();
      mapController = null;
      _places.endSession();
    });

    return const LocationPickerState(loaderState: LoaderState.loading);
  }

  /// Seeds camera from route args, or falls back to GPS.
  void applyInitialCoordinates({
    double? latitude,
    double? longitude,
  }) {
    if (_initialApplied) return;
    _initialApplied = true;

    if (latitude != null && longitude != null) {
      _cameraLat = latitude;
      _cameraLng = longitude;
      Future.microtask(() async {
        await _moveCamera(latitude, longitude);
        await reverseAt(latitude, longitude, force: true);
      });
      return;
    }

    Future.microtask(useCurrentLocation);
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    final pending = _pendingCameraTarget;
    if (pending != null) {
      _pendingCameraTarget = null;
      Future.microtask(() => _moveCamera(pending.latitude, pending.longitude));
    }
  }

  void onSearchChanged(String value) {
    _autocompleteTimer?.cancel();
    final query = value.trim();
    if (query.length < LocationConfig.minAutocompleteQueryLength) {
      state = state.copyWith(predictions: const [], isSearching: false);
      return;
    }

    state = state.copyWith(isSearching: true);
    _autocompleteTimer = Timer(
      Duration(milliseconds: LocationConfig.autocompleteDebounceMs),
      () => _runAutocomplete(query),
    );
  }

  Future<void> _runAutocomplete(String query) async {
    final generation = ++_autocompleteGeneration;
    _places.beginSession();
    final predictions = await _places.autocomplete(query);
    if (_disposed || generation != _autocompleteGeneration) return;
    state = state.copyWith(
      predictions: predictions,
      isSearching: false,
    );
  }

  void clearSearch() {
    searchController.clear();
    state = state.copyWith(predictions: const [], isSearching: false);
  }

  Future<void> selectPrediction(PlacePrediction prediction) async {
    state = state.copyWith(isReverseLoading: true, predictions: const []);
    final details = await _places.fetchDetails(prediction.placeId);
    if (_disposed) return;

    if (details == null) {
      state = state.copyWith(
        isReverseLoading: false,
        errorMessage: Strings.locationLookupFailed,
      );
      return;
    }

    await _moveCamera(details.latitude, details.longitude);
    final serviceable = isWithinDeliveryRadius(
      latitude: details.latitude,
      longitude: details.longitude,
    );
    state = state.copyWith(
      latitude: details.latitude,
      longitude: details.longitude,
      isReverseLoading: false,
      isServiceable: serviceable,
      errorMessage: serviceable ? null : Strings.locationNotServiceable,
      reverseResult: ReverseGeocodeResult(
        latitude: details.latitude,
        longitude: details.longitude,
        formattedAddress: details.formattedAddress,
        line1: details.line1,
        line2: details.line2,
        city: details.city,
        state: details.state,
        pincode: details.pincode,
        placeId: details.placeId,
      ),
      loaderState: LoaderState.loaded,
    );
    _lastReverseLat = details.latitude;
    _lastReverseLng = details.longitude;
    searchController.text = details.formattedAddress;
  }

  Future<void> useCurrentLocation() async {
    state = state.copyWith(loaderState: LoaderState.loading);
    final position = await _permission.getCurrentPosition();
    if (_disposed) return;

    if (position == null) {
      state = state.copyWith(
        loaderState: LoaderState.loaded,
        isServiceable: isWithinDeliveryRadius(
          latitude: LocationConfig.defaultLat,
          longitude: LocationConfig.defaultLng,
        ),
        errorMessage: Strings.locationPermissionDenied,
      );
      await _moveCamera(LocationConfig.defaultLat, LocationConfig.defaultLng);
      await reverseAt(
        LocationConfig.defaultLat,
        LocationConfig.defaultLng,
        force: true,
      );
      return;
    }

    var lat = position.latitude;
    var lng = position.longitude;
    // Emulators often GPS outside India — snap to delivery hub in mock/dev.
    if (!isWithinDeliveryRadius(latitude: lat, longitude: lng)) {
      debugPrint(
        "🟡 LOCATION: GPS outside delivery radius "
        "($lat,$lng) — using Mumbai default",
      );
      lat = LocationConfig.defaultLat;
      lng = LocationConfig.defaultLng;
    }

    await _moveCamera(lat, lng);
    await reverseAt(lat, lng, force: true);
  }

  void onCameraMove(CameraPosition position) {
    if (_programmaticMove) return;
    // Keep camera coords without notifying listeners every frame.
    _cameraLat = position.target.latitude;
    _cameraLng = position.target.longitude;
  }

  void onCameraIdle() {
    if (_programmaticMove) return;
    _reverseTimer?.cancel();
    final lat = _cameraLat;
    final lng = _cameraLng;
    _reverseTimer = Timer(
      Duration(milliseconds: LocationConfig.reverseGeocodeDebounceMs),
      () => reverseAt(lat, lng),
    );
  }

  Future<void> reverseAt(
    double latitude,
    double longitude, {
    bool force = false,
  }) async {
    if (!force) {
      final lastLat = _lastReverseLat;
      final lastLng = _lastReverseLng;
      if (lastLat != null && lastLng != null) {
        final moved = distanceMeters(
          fromLat: lastLat,
          fromLng: lastLng,
          toLat: latitude,
          toLng: longitude,
        );
        if (moved < LocationConfig.minMoveMetersForReverseGeocode) {
          return;
        }
      }
    }

    final generation = ++_reverseGeneration;
    state = state.copyWith(isReverseLoading: true);
    final result = await _geocode.reverseGeocode(
      latitude: latitude,
      longitude: longitude,
    );
    if (_disposed || generation != _reverseGeneration) return;

    final serviceable = isWithinDeliveryRadius(
      latitude: latitude,
      longitude: longitude,
    );

    if (result == null) {
      state = state.copyWith(
        latitude: latitude,
        longitude: longitude,
        isReverseLoading: false,
        isServiceable: serviceable,
        loaderState: LoaderState.loaded,
        errorMessage: serviceable
            ? Strings.locationLookupFailed
            : Strings.locationNotServiceable,
      );
      return;
    }

    _lastReverseLat = latitude;
    _lastReverseLng = longitude;
    _cameraLat = latitude;
    _cameraLng = longitude;
    state = state.copyWith(
      latitude: latitude,
      longitude: longitude,
      reverseResult: result,
      isReverseLoading: false,
      isServiceable: serviceable,
      loaderState: LoaderState.loaded,
      errorMessage: serviceable ? null : Strings.locationNotServiceable,
    );
  }

  PickedLocationModel? confirmSelection() {
    final reverse = state.reverseResult;
    if (!state.isServiceable || reverse == null) {
      state = state.copyWith(
        errorMessage: state.isServiceable
            ? Strings.locationLookupFailed
            : Strings.locationNotServiceable,
      );
      return null;
    }

    final pick = PickedLocationModel(
      latitude: reverse.latitude,
      longitude: reverse.longitude,
      formattedAddress: reverse.formattedAddress,
      line1: reverse.line1,
      line2: reverse.line2,
      city: reverse.city,
      state: reverse.state,
      pincode: reverse.pincode,
      placeId: reverse.placeId,
    );
    state = state.copyWith(confirmedPick: pick);
    return pick;
  }

  Future<void> _moveCamera(double lat, double lng) async {
    _cameraLat = lat;
    _cameraLng = lng;
    state = state.copyWith(latitude: lat, longitude: lng);

    final controller = mapController;
    if (controller == null) {
      _pendingCameraTarget = LatLng(lat, lng);
      return;
    }

    _programmaticMove = true;
    try {
      await controller.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(lat, lng), 16),
      );
      await Future<void>.delayed(const Duration(milliseconds: 320));
    } finally {
      _programmaticMove = false;
    }
  }
}

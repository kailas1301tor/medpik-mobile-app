// lib/src/address/notifier/location_picker_notifier.dart
//
// * Google Maps location picker — search, GPS, reverse geocode, serviceability.
//
// ? UX: fixed center pin (LocationPickerScreen). User pans map; on camera idle we
// ? debounce and reverse-geocode pin coordinates. Search = forward geocode + animate.
//
// ? Lifecycle: autoDispose — scoped to LocationPickerScreen only. Confirmed picks
// ? return via Navigator.pop(PickedLocationModel) → merged by AddressNotifier.
//
// ? Coordination flags:
// ? - _programmaticMove — skip onCameraMove during programmatic camera animation
// ? - _suppressNextCameraIdle — skip one idle after _moveCamera (no duplicate reverse)
// ? - _reverseGeneration — cancel stale reverse-geocode when newer request starts
//
// ? Serviceability: location_picker_confirm_helper + LocationConfig
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/services/location/geocode_client.dart';
import 'package:medpik/services/location/haversine.dart';
import 'package:medpik/services/location/location_config.dart';
import 'package:medpik/services/location/location_permission_service.dart';
import 'package:medpik/src/address/model/picked_location_model.dart';
import 'package:medpik/src/address/state/location_picker_state.dart';
import 'package:medpik/utils/helpers/location_picker_confirm_helper.dart';

part 'location_picker_notifier.g.dart';

@Riverpod(keepAlive: false)
class LocationPickerNotifier extends _$LocationPickerNotifier {
  late final TextEditingController searchController;
  late final GeocodeClient _geocode;
  late final LocationPermissionService _permission;

  GoogleMapController? mapController;
  Timer? _reverseTimer;
  double? _lastReverseLat;
  double? _lastReverseLng;
  bool _programmaticMove = false;
  bool _suppressNextCameraIdle = false;
  bool _initialApplied = false;
  bool _disposed = false;
  bool _mapReady = false;
  int _reverseGeneration = 0;
  DateTime? _lastGpsAt;
  LatLng? _pendingCameraTarget;
  double _cameraLat = LocationConfig.defaultLat;
  double _cameraLng = LocationConfig.defaultLng;

  @override
  LocationPickerState build() {
    searchController = TextEditingController();
    _geocode = ref.read(geocodeClientProvider);
    _permission = const LocationPermissionService();
    _disposed = false;
    _cameraLat = LocationConfig.defaultLat;
    _cameraLng = LocationConfig.defaultLng;

    ref.onDispose(() {
      _disposed = true;
      _reverseTimer?.cancel();
      searchController.dispose();
      mapController?.dispose();
      mapController = null;
    });

    if (!LocationConfig.hasGoogleMapsApiKey) {
      return const LocationPickerState(
        loaderState: LoaderState.loaded,
        errorMessage: Strings.locationMapsKeyMissing,
      );
    }

    return const LocationPickerState(loaderState: LoaderState.loading);
  }

  // ? Seeds camera from route args, or falls back to GPS (once per screen open).
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
    _mapReady = true;
    final pending = _pendingCameraTarget;
    if (pending != null) {
      _pendingCameraTarget = null;
      Future.microtask(() => _moveCamera(pending.latitude, pending.longitude));
    }
  }

  void clearSearch() {
    searchController.clear();
    state = state.copyWith(isSearching: false, searchErrorMessage: null);
  }

  // ? Forward geocode from searchController; moves map on success.
  Future<void> submitAddressSearch() async {
    final query = searchController.text.trim();
    if (query.length < LocationConfig.minSearchQueryLength) return;

    state = state.copyWith(
      isSearching: true,
      errorMessage: null,
      searchErrorMessage: null,
    );
    final result = await _geocode.forwardGeocode(address: query);
    if (_disposed) return;

    if (result == null) {
      state = state.copyWith(
        isSearching: false,
        reverseResult: null,
        searchErrorMessage: Strings.locationLookupFailed,
      );
      return;
    }

    await _applyGeocodeResult(result, moveCamera: true);
    searchController.text = result.formattedAddress;
    state = state.copyWith(isSearching: false);
  }

  // ? GPS centering — rate-limited by LocationConfig.useCurrentLocationCooldownMs.
  Future<void> useCurrentLocation() async {
    final now = DateTime.now();
    final lastGps = _lastGpsAt;
    if (lastGps != null &&
        now.difference(lastGps).inMilliseconds <
            LocationConfig.useCurrentLocationCooldownMs) {
      return;
    }

    state = state.copyWith(isReverseLoading: true, errorMessage: null);
    final position = await _permission.getCurrentPosition();
    if (_disposed) return;

    if (position == null) {
      state = state.copyWith(
        loaderState: LoaderState.loaded,
        isReverseLoading: false,
        reverseResult: null,
        isServiceable: isLocationServiceable(
          latitude: LocationConfig.defaultLat,
          longitude: LocationConfig.defaultLng,
          state: LocationConfig.deliveryState,
        ),
        errorMessage: Strings.locationPermissionDenied,
      );
      await _moveCamera(LocationConfig.defaultLat, LocationConfig.defaultLng);
      await reverseAt(
        LocationConfig.defaultLat,
        LocationConfig.defaultLng,
        force: true,
        preserveErrorMessage: Strings.locationPermissionDenied,
      );
      return;
    }

    _lastGpsAt = now;

    final lat = position.latitude;
    final lng = position.longitude;

    await _moveCamera(lat, lng);
    await reverseAt(lat, lng, force: true);
  }

  // ? Live camera position while user pans (ignored during programmatic moves).
  void onCameraMove(CameraPosition position) {
    if (_programmaticMove) return;
    _cameraLat = position.target.latitude;
    _cameraLng = position.target.longitude;
  }

  // ? Debounced reverse geocode when user stops panning.
  void onCameraIdle() {
    if (_programmaticMove || !_mapReady) return;
    if (_suppressNextCameraIdle) {
      _suppressNextCameraIdle = false;
      return;
    }
    _reverseTimer?.cancel();
    final lat = _cameraLat;
    final lng = _cameraLng;
    _reverseTimer = Timer(
      Duration(milliseconds: LocationConfig.reverseGeocodeDebounceMs),
      () => reverseAt(lat, lng),
    );
  }

  // ? Reverse geocode pin. Skips API if move < minMoveMeters unless force=true.
  Future<void> reverseAt(
    double latitude,
    double longitude, {
    bool force = false,
    String? preserveErrorMessage,
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

    if (!force &&
        shouldSkipReverseGeocodeApi(
          latitude: latitude,
          longitude: longitude,
        )) {
      _lastReverseLat = latitude;
      _lastReverseLng = longitude;
      state = state.copyWith(
        latitude: latitude,
        longitude: longitude,
        reverseResult: null,
        isReverseLoading: false,
        isServiceable: false,
        loaderState: LoaderState.loaded,
        errorMessage: Strings.locationNotServiceable,
      );
      return;
    }

    final generation = ++_reverseGeneration;
    state = state.copyWith(isReverseLoading: true, errorMessage: null);
    final result = await _geocode.reverseGeocode(
      latitude: latitude,
      longitude: longitude,
    );
    if (_disposed || generation != _reverseGeneration) return;

    final serviceable = isLocationServiceable(
      latitude: latitude,
      longitude: longitude,
      state: result?.state,
    );

    if (result == null) {
      state = state.copyWith(
        latitude: latitude,
        longitude: longitude,
        reverseResult: null,
        isReverseLoading: false,
        isServiceable: serviceable,
        loaderState: LoaderState.loaded,
        errorMessage: preserveErrorMessage ??
            (serviceable
                ? Strings.locationLookupFailed
                : Strings.locationNotServiceable),
      );
      return;
    }

    await _applyGeocodeResult(
      result,
      moveCamera: false,
      isReverseLoading: false,
      preserveErrorMessage: preserveErrorMessage,
    );
  }

  Future<void> _applyGeocodeResult(
    ReverseGeocodeResult result, {
    bool moveCamera = false,
    bool isReverseLoading = false,
    String? preserveErrorMessage,
  }) async {
    final serviceable = isLocationServiceable(
      latitude: result.latitude,
      longitude: result.longitude,
      state: result.state,
    );

    _lastReverseLat = result.latitude;
    _lastReverseLng = result.longitude;
    _cameraLat = result.latitude;
    _cameraLng = result.longitude;

    if (moveCamera) {
      await _moveCamera(result.latitude, result.longitude);
    }

    state = state.copyWith(
      latitude: result.latitude,
      longitude: result.longitude,
      reverseResult: result,
      isReverseLoading: isReverseLoading,
      isServiceable: serviceable,
      loaderState: LoaderState.loaded,
      errorMessage: preserveErrorMessage ??
          (serviceable ? null : Strings.locationNotServiceable),
    );
  }

  bool _canConfirmSelection() {
    return canConfirmLocationPicker(
      isServiceable: state.isServiceable,
      isReverseLoading: state.isReverseLoading,
      errorMessage: state.errorMessage,
      reverseResult: state.reverseResult,
      pinLat: state.latitude,
      pinLng: state.longitude,
    );
  }

  // * Builds PickedLocationModel for Navigator.pop after serviceability check.
  PickedLocationModel? confirmSelection() {
    if (!_canConfirmSelection()) {
      final reverse = state.reverseResult;
      state = state.copyWith(
        errorMessage: state.errorMessage ??
            (reverse == null
                ? Strings.locationLookupFailed
                : Strings.locationNotServiceable),
      );
      return null;
    }

    final reverse = state.reverseResult!;
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
    _suppressNextCameraIdle = true;
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
    } finally {
      _programmaticMove = false;
    }
  }
}

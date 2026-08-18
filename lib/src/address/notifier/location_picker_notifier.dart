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
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/services/location/geocode_client.dart';
import 'package:medpik/services/location/haversine.dart';
import 'package:medpik/services/location/location_access_status.dart';
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
  bool _initialScheduled = false;
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
    _permission = ref.read(locationPermissionServiceProvider);
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

    return const LocationPickerState(
      loaderState: LoaderState.loading,
      isInitialCameraReady: false,
    );
  }

  // ? One-shot entry from LocationPickerScreen — deferred past build (Riverpod rule).
  void scheduleInitialCoordinates({
    double? latitude,
    double? longitude,
  }) {
    if (_initialScheduled) return;
    _initialScheduled = true;
    Future.microtask(
      () => applyInitialCoordinates(latitude: latitude, longitude: longitude),
    );
  }

  // ? Resolves initial camera before GoogleMap mounts (GPS or route args).
  Future<void> applyInitialCoordinates({
    double? latitude,
    double? longitude,
  }) async {
    state = state.copyWith(
      loaderState: LoaderState.loading,
      isReverseLoading: true,
      errorMessage: null,
    );

    if (latitude != null && longitude != null) {
      _cameraLat = latitude;
      _cameraLng = longitude;
      state = state.copyWith(
        latitude: latitude,
        longitude: longitude,
        locationAccessIssue: null,
      );
      await reverseAt(latitude, longitude, force: true);
      if (_disposed) return;
      state = state.copyWith(
        loaderState: LoaderState.loaded,
        isInitialCameraReady: true,
      );
      return;
    }

    final access = await _permission.checkAccess();
    if (_disposed) return;

    if (access != LocationAccessStatus.granted) {
      await _showDefaultAreaWithAccessIssue(access);
      if (_disposed) return;
      state = state.copyWith(isInitialCameraReady: true);
      return;
    }

    final position = await _permission.getCurrentPosition(
      accuracy: LocationAccuracy.medium,
      timeLimit: const Duration(
        seconds: LocationConfig.gpsInitialTimeLimitSeconds,
      ),
      requestPermissionIfDenied: false,
    );
    if (_disposed) return;

    if (position == null) {
      await _showDefaultAreaWithGpsUnavailable();
      if (_disposed) return;
      state = state.copyWith(
        isInitialCameraReady: true,
        locationAccessIssue: null,
      );
      return;
    }

    _lastGpsAt = DateTime.now();
    final lat = position.latitude;
    final lng = position.longitude;
    _cameraLat = lat;
    _cameraLng = lng;
    state = state.copyWith(
      latitude: lat,
      longitude: lng,
      locationAccessIssue: null,
      errorMessage: null,
    );
    await reverseAt(lat, lng, force: true);
    if (_disposed) return;
    state = state.copyWith(
      loaderState: LoaderState.loaded,
      isInitialCameraReady: true,
    );
  }

  Future<void> refreshLocationAccess() async {
    if (_disposed) return;

    final access = await _permission.checkAccess();
    if (_disposed) return;

    if (access != LocationAccessStatus.granted) {
      state = state.copyWith(
        locationAccessIssue: access,
        errorMessage: _messageForAccessStatus(access),
      );
      return;
    }

    state = state.copyWith(
      locationAccessIssue: null,
      errorMessage: null,
      isReverseLoading: true,
    );

    final position = await _permission.getCurrentPosition(
      preferFresh: true,
      requestPermissionIfDenied: false,
    );
    if (_disposed) return;

    if (position == null) {
      state = state.copyWith(
        isReverseLoading: false,
        errorMessage: Strings.locationGpsUnavailable,
      );
      return;
    }

    _lastGpsAt = DateTime.now();
    final lat = position.latitude;
    final lng = position.longitude;
    await _moveCamera(lat, lng);
    await reverseAt(lat, lng, force: true);
  }

  Future<void> onLocationAccessAction() async {
    final issue = state.locationAccessIssue;
    if (issue == null) {
      await useCurrentLocation();
      return;
    }

    switch (issue) {
      case LocationAccessStatus.servicesDisabled:
        await _permission.openLocationSettings();
      case LocationAccessStatus.permissionDeniedForever:
        await _permission.openAppSettings();
      case LocationAccessStatus.permissionDenied:
        await useCurrentLocation();
      case LocationAccessStatus.granted:
        await useCurrentLocation();
    }
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

    state = state.copyWith(
      isReverseLoading: true,
      errorMessage: null,
    );

    final access = await _permission.resolveAccess(requestIfDenied: true);
    if (_disposed) return;

    if (access != LocationAccessStatus.granted) {
      state = state.copyWith(
        loaderState: LoaderState.loaded,
        isReverseLoading: false,
        locationAccessIssue: access,
        errorMessage: _messageForAccessStatus(access),
      );
      return;
    }

    final position = await _permission.getCurrentPosition(
      preferFresh: true,
      requestPermissionIfDenied: false,
    );
    if (_disposed) return;

    if (position == null) {
      state = state.copyWith(
        loaderState: LoaderState.loaded,
        isReverseLoading: false,
        locationAccessIssue: null,
        errorMessage: Strings.locationGpsUnavailable,
      );
      return;
    }

    _lastGpsAt = now;

    final lat = position.latitude;
    final lng = position.longitude;

    state = state.copyWith(
      locationAccessIssue: null,
      errorMessage: null,
    );
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

  Future<void> _showDefaultAreaWithAccessIssue(
    LocationAccessStatus access,
  ) async {
    final message = _messageForAccessStatus(access);
    _cameraLat = LocationConfig.defaultLat;
    _cameraLng = LocationConfig.defaultLng;
    state = state.copyWith(
      latitude: LocationConfig.defaultLat,
      longitude: LocationConfig.defaultLng,
      loaderState: LoaderState.loaded,
      isReverseLoading: false,
      reverseResult: null,
      locationAccessIssue: access,
      isServiceable: isLocationServiceable(
        latitude: LocationConfig.defaultLat,
        longitude: LocationConfig.defaultLng,
        state: LocationConfig.deliveryState,
      ),
      errorMessage: message,
    );
    await reverseAt(
      LocationConfig.defaultLat,
      LocationConfig.defaultLng,
      force: true,
      preserveErrorMessage: message,
    );
  }

  Future<void> _showDefaultAreaWithGpsUnavailable() async {
    _cameraLat = LocationConfig.defaultLat;
    _cameraLng = LocationConfig.defaultLng;
    state = state.copyWith(
      latitude: LocationConfig.defaultLat,
      longitude: LocationConfig.defaultLng,
      loaderState: LoaderState.loaded,
      isReverseLoading: false,
      reverseResult: null,
      locationAccessIssue: null,
      isServiceable: isLocationServiceable(
        latitude: LocationConfig.defaultLat,
        longitude: LocationConfig.defaultLng,
        state: LocationConfig.deliveryState,
      ),
      errorMessage: Strings.locationGpsUnavailable,
    );
    await reverseAt(
      LocationConfig.defaultLat,
      LocationConfig.defaultLng,
      force: true,
      preserveErrorMessage: Strings.locationGpsUnavailable,
    );
  }

  String _messageForAccessStatus(LocationAccessStatus status) {
    return switch (status) {
      LocationAccessStatus.servicesDisabled => Strings.locationServicesDisabled,
      LocationAccessStatus.permissionDenied =>
        Strings.locationPermissionRationale,
      LocationAccessStatus.permissionDeniedForever =>
        Strings.locationPermissionBlocked,
      LocationAccessStatus.granted => '',
    };
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

// lib/services/location/location_permission_service.dart
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medpik/services/location/location_access_status.dart';
import 'package:medpik/services/location/location_config.dart';

final locationPermissionServiceProvider = Provider<LocationPermissionService>(
  (ref) => const LocationPermissionService(),
);

class LocationPermissionService {
  const LocationPermissionService();

  Future<LocationAccessStatus> checkAccess() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('🟡 LOCATION: services disabled');
        return LocationAccessStatus.servicesDisabled;
      }

      return _mapPermission(await Geolocator.checkPermission());
    } on MissingPluginException catch (e) {
      debugPrint(
        '🔴 LOCATION: plugin not linked — do a full stop + rebuild '
        '(hot reload is not enough after adding geolocator): $e',
      );
      return LocationAccessStatus.permissionDenied;
    } on PlatformException catch (e) {
      debugPrint('🔴 LOCATION: platform error: $e');
      return LocationAccessStatus.permissionDenied;
    } catch (e) {
      debugPrint('🔴 LOCATION: unexpected permission error: $e');
      return LocationAccessStatus.permissionDenied;
    }
  }

  Future<LocationAccessStatus> resolveAccess({
    bool requestIfDenied = false,
  }) async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('🟡 LOCATION: services disabled');
        return LocationAccessStatus.servicesDisabled;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied && requestIfDenied) {
        permission = await Geolocator.requestPermission();
      }

      return _mapPermission(permission);
    } on MissingPluginException catch (e) {
      debugPrint(
        '🔴 LOCATION: plugin not linked — do a full stop + rebuild '
        '(hot reload is not enough after adding geolocator): $e',
      );
      return LocationAccessStatus.permissionDenied;
    } on PlatformException catch (e) {
      debugPrint('🔴 LOCATION: platform error: $e');
      return LocationAccessStatus.permissionDenied;
    } catch (e) {
      debugPrint('🔴 LOCATION: unexpected permission error: $e');
      return LocationAccessStatus.permissionDenied;
    }
  }

  Future<bool> ensurePermission() async {
    final status = await resolveAccess(requestIfDenied: true);
    return status == LocationAccessStatus.granted;
  }

  Future<bool> openLocationSettings() async {
    try {
      return await Geolocator.openLocationSettings();
    } catch (e) {
      debugPrint('🔴 LOCATION: openLocationSettings failed: $e');
      return false;
    }
  }

  Future<bool> openAppSettings() async {
    try {
      return await Geolocator.openAppSettings();
    } catch (e) {
      debugPrint('🔴 LOCATION: openAppSettings failed: $e');
      return false;
    }
  }

  /// Last-known (fast) then fresh GPS. [preferFresh] skips cache for explicit recenter.
  Future<Position?> getCurrentPosition({
    bool preferFresh = false,
    LocationAccuracy accuracy = LocationAccuracy.high,
    Duration timeLimit = const Duration(
      seconds: LocationConfig.gpsRefreshTimeLimitSeconds,
    ),
    bool requestPermissionIfDenied = true,
  }) async {
    final access = await resolveAccess(requestIfDenied: requestPermissionIfDenied);
    if (access != LocationAccessStatus.granted) return null;

    if (!preferFresh) {
      final lastKnown = await _getLastKnownPosition();
      if (lastKnown != null) return lastKnown;
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: accuracy,
          timeLimit: timeLimit,
        ),
      );
    } on MissingPluginException catch (e) {
      debugPrint('🔴 LOCATION: plugin missing on getCurrentPosition: $e');
      return _getLastKnownPosition();
    } on PlatformException catch (e) {
      debugPrint('🔴 LOCATION: getCurrentPosition platform error: $e');
      return preferFresh ? null : await _getLastKnownPosition();
    } on TimeoutException catch (e) {
      debugPrint('🟡 LOCATION: getCurrentPosition timed out: $e');
      return preferFresh ? null : await _getLastKnownPosition();
    } catch (e) {
      debugPrint('🔴 LOCATION: getCurrentPosition failed: $e');
      return preferFresh ? null : await _getLastKnownPosition();
    }
  }

  LocationAccessStatus _mapPermission(LocationPermission permission) {
    return switch (permission) {
      LocationPermission.always ||
      LocationPermission.whileInUse =>
        LocationAccessStatus.granted,
      LocationPermission.denied => LocationAccessStatus.permissionDenied,
      LocationPermission.deniedForever =>
        LocationAccessStatus.permissionDeniedForever,
      LocationPermission.unableToDetermine =>
        LocationAccessStatus.permissionDenied,
    };
  }

  Future<Position?> _getLastKnownPosition() async {
    try {
      return await Geolocator.getLastKnownPosition();
    } on MissingPluginException catch (e) {
      debugPrint('🔴 LOCATION: plugin missing on getLastKnownPosition: $e');
      return null;
    } on PlatformException catch (e) {
      debugPrint('🔴 LOCATION: getLastKnownPosition platform error: $e');
      return null;
    } catch (e) {
      debugPrint('🟡 LOCATION: getLastKnownPosition failed: $e');
      return null;
    }
  }
}

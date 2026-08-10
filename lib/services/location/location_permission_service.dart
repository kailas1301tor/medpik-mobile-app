// lib/services/location/location_permission_service.dart
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medpik/services/location/location_config.dart';

final locationPermissionServiceProvider = Provider<LocationPermissionService>(
  (ref) => const LocationPermissionService(),
);

class LocationPermissionService {
  const LocationPermissionService();

  Future<bool> ensurePermission() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint("🟡 LOCATION: services disabled");
        return false;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        debugPrint("🟡 LOCATION: permission denied ($permission)");
        return false;
      }

      return true;
    } on MissingPluginException catch (e) {
      debugPrint(
        "🔴 LOCATION: plugin not linked — do a full stop + rebuild "
        "(hot reload is not enough after adding geolocator): $e",
      );
      return false;
    } on PlatformException catch (e) {
      debugPrint("🔴 LOCATION: platform error: $e");
      return false;
    } catch (e) {
      debugPrint("🔴 LOCATION: unexpected permission error: $e");
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
  }) async {
    final allowed = await ensurePermission();
    if (!allowed) return null;

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
      debugPrint("🔴 LOCATION: plugin missing on getCurrentPosition: $e");
      return _getLastKnownPosition();
    } on PlatformException catch (e) {
      debugPrint("🔴 LOCATION: getCurrentPosition platform error: $e");
      return preferFresh ? null : await _getLastKnownPosition();
    } on TimeoutException catch (e) {
      debugPrint("🟡 LOCATION: getCurrentPosition timed out: $e");
      return preferFresh ? null : await _getLastKnownPosition();
    } catch (e) {
      debugPrint("🔴 LOCATION: getCurrentPosition failed: $e");
      return preferFresh ? null : await _getLastKnownPosition();
    }
  }

  Future<Position?> _getLastKnownPosition() async {
    try {
      return await Geolocator.getLastKnownPosition();
    } on MissingPluginException catch (e) {
      debugPrint("🔴 LOCATION: plugin missing on getLastKnownPosition: $e");
      return null;
    } on PlatformException catch (e) {
      debugPrint("🔴 LOCATION: getLastKnownPosition platform error: $e");
      return null;
    } catch (e) {
      debugPrint("🟡 LOCATION: getLastKnownPosition failed: $e");
      return null;
    }
  }
}

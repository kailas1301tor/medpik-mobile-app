// lib/services/location/location_permission_service.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

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

  Future<Position?> getCurrentPosition() async {
    final allowed = await ensurePermission();
    if (!allowed) return null;

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 12),
        ),
      );
    } on MissingPluginException catch (e) {
      debugPrint("🔴 LOCATION: plugin missing on getCurrentPosition: $e");
      return null;
    } on PlatformException catch (e) {
      debugPrint("🔴 LOCATION: getCurrentPosition platform error: $e");
      return null;
    } catch (e) {
      debugPrint("🔴 LOCATION: getCurrentPosition failed: $e");
      return null;
    }
  }
}

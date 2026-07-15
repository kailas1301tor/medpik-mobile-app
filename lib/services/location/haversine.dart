// lib/services/location/haversine.dart
import 'dart:math' as math;

import 'package:tsuite/services/location/location_config.dart';

double distanceMeters({
  required double fromLat,
  required double fromLng,
  required double toLat,
  required double toLng,
}) {
  const earthRadiusM = 6371000.0;
  final dLat = _toRadians(toLat - fromLat);
  final dLng = _toRadians(toLng - fromLng);
  final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(_toRadians(fromLat)) *
          math.cos(_toRadians(toLat)) *
          math.sin(dLng / 2) *
          math.sin(dLng / 2);
  final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  return earthRadiusM * c;
}

bool isWithinDeliveryRadius({
  required double latitude,
  required double longitude,
}) {
  final meters = distanceMeters(
    fromLat: LocationConfig.deliveryHubLat,
    fromLng: LocationConfig.deliveryHubLng,
    toLat: latitude,
    toLng: longitude,
  );
  return meters <= LocationConfig.deliveryRadiusKm * 1000;
}

double _toRadians(double degrees) => degrees * math.pi / 180;

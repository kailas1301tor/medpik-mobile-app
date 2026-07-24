// lib/services/location/haversine.dart
import 'dart:math' as math;

import 'package:medpik/services/location/location_config.dart';

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

bool isDeliveryState(String? state) {
  if (state == null || state.trim().isEmpty) return false;
  return state.trim().toLowerCase() ==
      LocationConfig.deliveryState.toLowerCase();
}

/// Serviceable when geocoded state is Kerala, or coords within hub radius.
bool isLocationServiceable({
  required double latitude,
  required double longitude,
  String? state,
}) {
  if (isDeliveryState(state)) return true;
  return isWithinDeliveryRadius(latitude: latitude, longitude: longitude);
}

bool isWithinKeralaBoundingBox({
  required double latitude,
  required double longitude,
}) {
  return latitude >= LocationConfig.keralaMinLat &&
      latitude <= LocationConfig.keralaMaxLat &&
      longitude >= LocationConfig.keralaMinLng &&
      longitude <= LocationConfig.keralaMaxLng;
}

/// Skips reverse-geocode HTTP when the pin is clearly outside the service area.
bool shouldSkipReverseGeocodeApi({
  required double latitude,
  required double longitude,
}) {
  if (isWithinDeliveryRadius(latitude: latitude, longitude: longitude)) {
    return false;
  }
  if (isWithinKeralaBoundingBox(
    latitude: latitude,
    longitude: longitude,
  )) {
    return false;
  }
  return true;
}

/// True when the geocoded point matches the map pin within [toleranceMeters].
bool isReverseGeocodeMatchingPin({
  required double pinLat,
  required double pinLng,
  required double resultLat,
  required double resultLng,
  double toleranceMeters = LocationConfig.minMoveMetersForReverseGeocode,
}) {
  return distanceMeters(
        fromLat: pinLat,
        fromLng: pinLng,
        toLat: resultLat,
        toLng: resultLng,
      ) <=
      toleranceMeters;
}

double _toRadians(double degrees) => degrees * math.pi / 180;

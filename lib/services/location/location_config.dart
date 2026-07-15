// lib/services/location/location_config.dart
import 'package:tsuite/res/constants/app_constants.dart';

class LocationConfig {
  LocationConfig._();

  /// Resolved Maps / Places / Geocoding key for Dart HTTP clients.
  /// Prefer `--dart-define=GOOGLE_MAPS_API_KEY=...` in CI/flavors.
  static String get googleMapsApiKey {
    const fromEnv = String.fromEnvironment('GOOGLE_MAPS_API_KEY');
    if (fromEnv.isNotEmpty) return fromEnv;
    return AppConstants.googleApiKey;
  }

  /// Default map center (Mumbai Andheri) before GPS / pick.
  static const double defaultLat = 19.1136;
  static const double defaultLng = 72.8697;

  /// Delivery hub for Haversine serviceability (Mumbai).
  static const double deliveryHubLat = 19.0760;
  static const double deliveryHubLng = 72.8777;
  static const double deliveryRadiusKm = 25;

  static const int autocompleteDebounceMs = 400;
  static const int reverseGeocodeDebounceMs = 500;
  static const int minAutocompleteQueryLength = 3;

  /// Skip reverse geocode if camera moved less than this (meters).
  static const double minMoveMetersForReverseGeocode = 30;

  static const String placesComponents = 'country:in';
  static const int geocodeCacheMaxEntries = 64;
}

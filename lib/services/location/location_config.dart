// lib/services/location/location_config.dart
import 'package:medpik/res/constants/app_constants.dart';

class LocationConfig {
  LocationConfig._();

  /// Resolved Geocoding key for Dart HTTP clients.
  /// Prefer `--dart-define-from-file=config/dart_defines.json` (see bootstrap script).
  static String get googleMapsApiKey {
    const fromEnv = String.fromEnvironment('GOOGLE_MAPS_API_KEY');
    if (fromEnv.isNotEmpty) return fromEnv;
    return AppConstants.googleApiKey;
  }

  static bool get hasGoogleMapsApiKey => googleMapsApiKey.isNotEmpty;

  /// Default map center (Thrissur, Kerala) before GPS / pick.
  static const double defaultLat = 10.5241;
  static const double defaultLng = 76.2121;

  /// Delivery hub for Haversine fallback (Thrissur).
  static const double deliveryHubLat = 10.5241;
  static const double deliveryHubLng = 76.2121;

  /// Fallback radius when state is not yet known (pin drag before geocode).
  static const double deliveryRadiusKm = 150;

  /// Serviceable when reverse-geocoded [administrative_area_level_1] matches.
  static const String deliveryState = 'Kerala';

  static const int reverseGeocodeDebounceMs = 700;
  static const int minSearchQueryLength = 3;

  /// Skip reverse geocode if camera moved less than this (meters).
  static const double minMoveMetersForReverseGeocode = 50;

  /// Coarser grid (~111 m) improves cache hits during small map pans.
  static const int geocodeCacheLatLngDecimals = 3;

  static const String geocodeCountryBias = 'country:in';

  /// Biases forward-geocode results toward India (used with [geocodeCountryBias]).
  static const String geocodeRegionBias = 'in';
  static const int geocodeCacheMaxEntries = 96;

  /// Cooldown between GPS "use current location" taps.
  static const int useCurrentLocationCooldownMs = 2000;

  /// Initial map open — prefer last-known; shorter fresh-GPS wait.
  static const int gpsInitialTimeLimitSeconds = 8;

  /// "Use current location" tap — allow longer high-accuracy fix.
  static const int gpsRefreshTimeLimitSeconds = 12;

  /// Default map zoom for location picker initial camera.
  static const double mapDefaultZoom = 15;

  /// Kerala bounding box — used to skip geocode API far outside service area.
  static const double keralaMinLat = 8.0;
  static const double keralaMaxLat = 12.85;
  static const double keralaMinLng = 74.75;
  static const double keralaMaxLng = 77.85;
}

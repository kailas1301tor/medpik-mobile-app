// lib/services/location/geocode_client.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/services/location/location_config.dart';
import 'package:medpik/utils/helpers/geocode_address_formatter.dart';

part 'geocode_client.g.dart';

class ReverseGeocodeResult {
  const ReverseGeocodeResult({
    required this.latitude,
    required this.longitude,
    required this.formattedAddress,
    this.line1 = '',
    this.line2 = '',
    this.city = '',
    this.state = '',
    this.pincode = '',
    this.placeId,
  });

  final double latitude;
  final double longitude;
  final String formattedAddress;
  final String line1;
  final String line2;
  final String city;
  final String state;
  final String pincode;
  final String? placeId;
}

class GeocodeLruCache {
  final Map<String, ReverseGeocodeResult> _entries = {};

  String keyForLatLng(double lat, double lng) {
    final decimals = LocationConfig.geocodeCacheLatLngDecimals;
    return '${lat.toStringAsFixed(decimals)},${lng.toStringAsFixed(decimals)}';
  }

  String keyForQuery(String address) {
    return 'q:${address.trim().toLowerCase()}';
  }

  ReverseGeocodeResult? get(String key) {
    final value = _entries.remove(key);
    if (value == null) return null;
    _entries[key] = value;
    return value;
  }

  void put(String key, ReverseGeocodeResult value) {
    _entries.remove(key);
    _entries[key] = value;
    while (_entries.length > LocationConfig.geocodeCacheMaxEntries) {
      _entries.remove(_entries.keys.first);
    }
  }
}

class GeocodeClient {
  GeocodeClient({Dio? dio, GeocodeLruCache? cache})
      : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 12),
                receiveTimeout: const Duration(seconds: 12),
              ),
            ),
        _cache = cache ?? GeocodeLruCache();

  final Dio _dio;
  final GeocodeLruCache _cache;
  static bool _loggedMissingKey = false;

  bool _ensureApiKey() {
    if (LocationConfig.hasGoogleMapsApiKey) return true;
    if (!_loggedMissingKey) {
      _loggedMissingKey = true;
      debugPrint(
        "🔴 GEOCODE: missing API key — set GOOGLE_GEOCODING_KEY in "
        "config/secrets.local.json and run tool/bootstrap_secrets.sh",
      );
    }
    return false;
  }

  Future<ReverseGeocodeResult?> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    final cacheKey = _cache.keyForLatLng(latitude, longitude);
    final cached = _cache.get(cacheKey);
    if (cached != null) {
      debugPrint("🟢 GEOCODE CACHE HIT: $cacheKey");
      return cached;
    }

    if (!_ensureApiKey()) return null;

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParameters: {
          'latlng': '$latitude,$longitude',
          'key': LocationConfig.googleMapsApiKey,
          'language': 'en',
        },
      );

      final result = _parseFirstResult(
        data: response.data ?? const {},
        fallbackLat: latitude,
        fallbackLng: longitude,
      );
      if (result == null) return null;

      _cache.put(cacheKey, result);
      debugPrint("🟢 GEOCODE SUCCESS: $cacheKey");
      return result;
    } catch (e) {
      debugPrint("🔴 GEOCODE ERROR: $e");
      return null;
    }
  }

  Future<ReverseGeocodeResult?> forwardGeocode({
    required String address,
  }) async {
    final query = address.trim();
    if (query.length < LocationConfig.minSearchQueryLength) return null;

    final cacheKey = _cache.keyForQuery(query);
    final cached = _cache.get(cacheKey);
    if (cached != null) {
      debugPrint("🟢 FORWARD GEOCODE CACHE HIT: $cacheKey");
      return cached;
    }

    if (!_ensureApiKey()) return null;

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParameters: {
          'address': query,
          'key': LocationConfig.googleMapsApiKey,
          'language': 'en',
          'components': LocationConfig.geocodeCountryBias,
          'region': LocationConfig.geocodeRegionBias,
        },
      );

      final result = _parseFirstResult(data: response.data ?? const {});
      if (result == null) {
        debugPrint("🟡 FORWARD GEOCODE: no results for $cacheKey");
        return null;
      }

      _cache.put(cacheKey, result);
      _cache.put(
        _cache.keyForLatLng(result.latitude, result.longitude),
        result,
      );
      debugPrint("🟢 FORWARD GEOCODE SUCCESS: $cacheKey");
      return result;
    } catch (e) {
      debugPrint("🔴 FORWARD GEOCODE ERROR: $e");
      return null;
    }
  }

  ReverseGeocodeResult? _parseFirstResult({
    required Map<String, dynamic> data,
    double? fallbackLat,
    double? fallbackLng,
  }) {
    final status = data['status']?.toString() ?? '';
    if (status == 'ZERO_RESULTS') return null;
    if (status != 'OK') {
      debugPrint("🔴 GEOCODE: $status ${data['error_message']}");
      return null;
    }

    final results = data['results'];
    if (results is! List || results.isEmpty) return null;

    final first = Map<String, dynamic>.from(results.first as Map);
    final geometry = Map<String, dynamic>.from(
      (first['geometry'] as Map?) ?? const {},
    );
    final location = Map<String, dynamic>.from(
      (geometry['location'] as Map?) ?? const {},
    );
    final lat = (location['lat'] as num?)?.toDouble() ?? fallbackLat;
    final lng = (location['lng'] as num?)?.toDouble() ?? fallbackLng;
    if (lat == null || lng == null) return null;

    final components = _parseGeocodeComponents(first['address_components']);
    final rawFormatted = first['formatted_address']?.toString() ?? '';
    return ReverseGeocodeResult(
      latitude: lat,
      longitude: lng,
      formattedAddress: formatGeocodeDisplayAddress(rawFormatted),
      line1: components.line1,
      line2: components.line2,
      city: components.city,
      state: components.state,
      pincode: components.pincode,
      placeId: first['place_id']?.toString(),
    );
  }
}

class _GeocodeParts {
  const _GeocodeParts({
    this.line1 = '',
    this.line2 = '',
    this.city = '',
    this.state = '',
    this.pincode = '',
  });

  final String line1;
  final String line2;
  final String city;
  final String state;
  final String pincode;
}

_GeocodeParts _parseGeocodeComponents(dynamic raw) {
  if (raw is! List) return const _GeocodeParts();

  String route = '';
  String streetNumber = '';
  String sublocality = '';
  String locality = '';
  String admin1 = '';
  String postal = '';

  for (final item in raw) {
    if (item is! Map) continue;
    final map = Map<String, dynamic>.from(item);
    final types = (map['types'] as List?)?.map((e) => e.toString()).toList() ??
        const <String>[];
    final longName = map['long_name']?.toString() ?? '';
    if (types.contains('street_number')) streetNumber = longName;
    if (types.contains('route')) route = longName;
    if (types.contains('sublocality') ||
        types.contains('sublocality_level_1')) {
      sublocality = longName;
    }
    if (types.contains('locality')) locality = longName;
    if (types.contains('administrative_area_level_1')) admin1 = longName;
    if (types.contains('postal_code')) postal = longName;
  }

  final line1 = [streetNumber, route].where((e) => e.isNotEmpty).join(' ');
  return _GeocodeParts(
    line1: line1.isNotEmpty ? line1 : sublocality,
    line2: sublocality,
    city: locality,
    state: admin1,
    pincode: postal,
  );
}

@Riverpod(keepAlive: true)
GeocodeClient geocodeClient(Ref ref) => GeocodeClient();

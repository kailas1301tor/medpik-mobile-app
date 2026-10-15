// lib/services/location/geocode_client.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/services/location/location_config.dart';
import 'package:medpik/utils/helpers/forward_geocode_filter.dart';
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
  final Map<String, List<ReverseGeocodeResult>> _listEntries = {};

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

  /// Exact-query forward pick list. Different queries never collide.
  List<ReverseGeocodeResult>? getList(String key) {
    final value = _listEntries.remove(key);
    if (value == null) return null;
    _listEntries[key] = value;
    return List<ReverseGeocodeResult>.unmodifiable(value);
  }

  void putList(String key, List<ReverseGeocodeResult> value) {
    _listEntries.remove(key);
    _listEntries[key] = List<ReverseGeocodeResult>.unmodifiable(value);
    while (_listEntries.length > LocationConfig.geocodeCacheMaxEntries) {
      _listEntries.remove(_listEntries.keys.first);
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
      _logResultSummary(
        tag: 'GEOCODE CACHE HIT',
        cacheKey: cacheKey,
        result: cached,
      );
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

      final data = response.data ?? const <String, dynamic>{};
      final results = _parseResults(
        data: data,
        fallbackLat: latitude,
        fallbackLng: longitude,
      );
      _logApiResponse(tag: 'REVERSE GEOCODE', data: data, results: results);

      if (results.isEmpty) return null;

      final result = results.first;
      _cache.put(cacheKey, result);
      return result;
    } catch (e) {
      debugPrint("🔴 GEOCODE ERROR: $e");
      return null;
    }
  }

  /// Prefer [forwardGeocodeResults] when the UI needs a pick list.
  Future<ReverseGeocodeResult?> forwardGeocode({
    required String address,
  }) async {
    final results = await forwardGeocodeResults(address: address);
    return results.isEmpty ? null : results.first;
  }

  Future<List<ReverseGeocodeResult>> forwardGeocodeResults({
    required String address,
  }) async {
    final query = address.trim();
    if (query.length < LocationConfig.minSearchQueryLength) {
      return const [];
    }

    final cacheKey = _cache.keyForQuery(query);
    final cached = _cache.getList(cacheKey);
    if (cached != null) {
      debugPrint(
        '🟢 FORWARD GEOCODE CACHE HIT: key=$cacheKey count=${cached.length}',
      );
      for (var i = 0; i < cached.length && i < 5; i++) {
        _logResultSummary(
          tag: 'FORWARD GEOCODE CACHE[$i]',
          cacheKey: cacheKey,
          result: cached[i],
        );
      }
      return cached;
    }

    if (!_ensureApiKey()) return const [];

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParameters: {
          'address': query,
          'key': LocationConfig.googleMapsApiKey,
          'language': 'en',
          'components': LocationConfig.geocodeCountryBias,
          'region': LocationConfig.geocodeRegionBias,
          // Bias toward service area (still may return coarse hits — filtered below).
          'bounds':
              '${LocationConfig.keralaMinLat},${LocationConfig.keralaMinLng}|'
              '${LocationConfig.keralaMaxLat},${LocationConfig.keralaMaxLng}',
        },
      );

      final data = response.data ?? const <String, dynamic>{};
      final results = _parseResults(
        data: data,
        forForwardPickList: true,
      );
      _logApiResponse(
        tag: 'FORWARD GEOCODE',
        data: data,
        results: results,
        cacheKey: cacheKey,
      );

      if (results.isEmpty) return const [];

      final capped = results
          .take(LocationConfig.maxForwardSearchResults)
          .toList(growable: false);

      for (final result in capped) {
        _cache.put(
          _cache.keyForLatLng(result.latitude, result.longitude),
          result,
        );
      }
      _cache.putList(cacheKey, capped);
      return capped;
    } catch (e) {
      debugPrint("🔴 FORWARD GEOCODE ERROR: $e");
      return const [];
    }
  }

  List<ReverseGeocodeResult> _parseResults({
    required Map<String, dynamic> data,
    double? fallbackLat,
    double? fallbackLng,
    bool forForwardPickList = false,
  }) {
    final status = data['status']?.toString() ?? '';
    if (status == 'ZERO_RESULTS') return const [];
    if (status != 'OK') {
      debugPrint("🔴 GEOCODE: $status ${data['error_message']}");
      return const [];
    }

    final rawResults = data['results'];
    if (rawResults is! List || rawResults.isEmpty) return const [];

    final parsed = <ReverseGeocodeResult>[];
    for (final item in rawResults) {
      if (item is! Map) continue;
      final result = _parseResultMap(
        Map<String, dynamic>.from(item),
        fallbackLat: fallbackLat,
        fallbackLng: fallbackLng,
        forForwardPickList: forForwardPickList,
      );
      if (result != null) parsed.add(result);
    }
    return parsed;
  }

  ReverseGeocodeResult? _parseResultMap(
    Map<String, dynamic> first, {
    double? fallbackLat,
    double? fallbackLng,
    bool forForwardPickList = false,
  }) {
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
    final types = (first['types'] as List?)
            ?.map((e) => e.toString())
            .toList(growable: false) ??
        const <String>[];

    if (forForwardPickList &&
        !isUsefulForwardGeocodeResult(
          types: types,
          latitude: lat,
          longitude: lng,
          state: components.state,
        )) {
      debugPrint(
        '🟡 FORWARD GEOCODE SKIP: coarse/out-of-area '
        'types=$types address=${first['formatted_address']}',
      );
      return null;
    }

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

  void _logApiResponse({
    required String tag,
    required Map<String, dynamic> data,
    required List<ReverseGeocodeResult> results,
    String? cacheKey,
  }) {
    final status = data['status']?.toString() ?? '';
    final keyPart = cacheKey == null ? '' : ' key=$cacheKey';
    debugPrint(
      '🟢 $tag RESPONSE: status=$status count=${results.length}$keyPart',
    );
    for (var i = 0; i < results.length && i < 5; i++) {
      _logResultSummary(
        tag: '$tag[$i]',
        cacheKey: cacheKey ?? '',
        result: results[i],
      );
    }
  }

  void _logResultSummary({
    required String tag,
    required String cacheKey,
    required ReverseGeocodeResult result,
  }) {
    final place = result.placeId ?? '';
    debugPrint(
      '🟢 $tag: $cacheKey\n'
      '   address=${result.formattedAddress}\n'
      '   lat=${result.latitude} lng=${result.longitude} '
      'state=${result.state} place_id=$place',
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

// lib/services/location/places_session_client.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:tsuite/res/constants/app_constants.dart';
import 'package:tsuite/services/location/location_config.dart';
import 'package:tsuite/services/location/location_mock_data.dart';
import 'package:uuid/uuid.dart';

class PlacePrediction {
  const PlacePrediction({
    required this.placeId,
    required this.primaryText,
    required this.secondaryText,
  });

  final String placeId;
  final String primaryText;
  final String secondaryText;
}

class PlaceDetailsResult {
  const PlaceDetailsResult({
    required this.placeId,
    required this.latitude,
    required this.longitude,
    required this.formattedAddress,
    this.line1 = '',
    this.line2 = '',
    this.city = '',
    this.state = '',
    this.pincode = '',
  });

  final String placeId;
  final double latitude;
  final double longitude;
  final String formattedAddress;
  final String line1;
  final String line2;
  final String city;
  final String state;
  final String pincode;
}

/// Places Autocomplete + Details with per-session billing tokens.
class PlacesSessionClient {
  PlacesSessionClient({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 12),
                receiveTimeout: const Duration(seconds: 12),
              ),
            );

  final Dio _dio;
  final Uuid _uuid = const Uuid();
  String? _sessionToken;

  void beginSession() {
    if (_sessionToken != null) return;
    _sessionToken = _uuid.v4();
    debugPrint("🔵 PLACES: session started");
  }

  void endSession() {
    if (_sessionToken != null) {
      debugPrint("🔵 PLACES: session ended");
    }
    _sessionToken = null;
  }

  String _ensureSession() {
    _sessionToken ??= _uuid.v4();
    return _sessionToken!;
  }

  Future<List<PlacePrediction>> autocomplete(String input) async {
    final query = input.trim();
    if (query.length < LocationConfig.minAutocompleteQueryLength) {
      return const [];
    }

    if (AppConstants.useMockData) {
      debugPrint("🟢 PLACES MOCK AUTOCOMPLETE: $query");
      await Future<void>.delayed(const Duration(milliseconds: 180));
      return LocationMockData.autocomplete(query);
    }

    final token = _ensureSession();
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json',
        queryParameters: {
          'input': query,
          'key': LocationConfig.googleMapsApiKey,
          'sessiontoken': token,
          'components': LocationConfig.placesComponents,
          'language': 'en',
        },
      );

      final data = response.data ?? const {};
      final status = data['status']?.toString() ?? '';
      if (status != 'OK' && status != 'ZERO_RESULTS') {
        debugPrint("🔴 PLACES AUTOCOMPLETE: $status ${data['error_message']}");
        return const [];
      }

      final predictions = data['predictions'];
      if (predictions is! List) return const [];

      return predictions.map((raw) {
        final map = Map<String, dynamic>.from(raw as Map);
        final structured = Map<String, dynamic>.from(
          (map['structured_formatting'] as Map?) ?? const {},
        );
        return PlacePrediction(
          placeId: map['place_id']?.toString() ?? '',
          primaryText: structured['main_text']?.toString() ??
              map['description']?.toString() ??
              '',
          secondaryText: structured['secondary_text']?.toString() ?? '',
        );
      }).where((p) => p.placeId.isNotEmpty).toList();
    } catch (e) {
      debugPrint("🔴 PLACES AUTOCOMPLETE ERROR: $e");
      return const [];
    }
  }

  Future<PlaceDetailsResult?> fetchDetails(String placeId) async {
    if (placeId.isEmpty) return null;

    if (AppConstants.useMockData) {
      debugPrint("🟢 PLACES MOCK DETAILS: $placeId");
      await Future<void>.delayed(const Duration(milliseconds: 150));
      endSession();
      return LocationMockData.details(placeId);
    }

    final token = _ensureSession();

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'https://maps.googleapis.com/maps/api/place/details/json',
        queryParameters: {
          'place_id': placeId,
          'fields': 'place_id,geometry,formatted_address,address_component',
          'key': LocationConfig.googleMapsApiKey,
          'sessiontoken': token,
          'language': 'en',
        },
      );

      endSession();

      final data = response.data ?? const {};
      final status = data['status']?.toString() ?? '';
      if (status != 'OK') {
        debugPrint("🔴 PLACE DETAILS: $status ${data['error_message']}");
        return null;
      }

      final result = Map<String, dynamic>.from(
        (data['result'] as Map?) ?? const {},
      );
      final geometry = Map<String, dynamic>.from(
        (result['geometry'] as Map?) ?? const {},
      );
      final location = Map<String, dynamic>.from(
        (geometry['location'] as Map?) ?? const {},
      );
      final lat = (location['lat'] as num?)?.toDouble();
      final lng = (location['lng'] as num?)?.toDouble();
      if (lat == null || lng == null) return null;

      final components = _parseComponents(result['address_components']);
      return PlaceDetailsResult(
        placeId: result['place_id']?.toString() ?? placeId,
        latitude: lat,
        longitude: lng,
        formattedAddress: result['formatted_address']?.toString() ?? '',
        line1: components.line1,
        line2: components.line2,
        city: components.city,
        state: components.state,
        pincode: components.pincode,
      );
    } catch (e) {
      debugPrint("🔴 PLACE DETAILS ERROR: $e");
      endSession();
      return null;
    }
  }
}

class _AddressParts {
  const _AddressParts({
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

_AddressParts _parseComponents(dynamic raw) {
  if (raw is! List) return const _AddressParts();

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
  return _AddressParts(
    line1: line1.isNotEmpty ? line1 : sublocality,
    line2: sublocality,
    city: locality,
    state: admin1,
    pincode: postal,
  );
}

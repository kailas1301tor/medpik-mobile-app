// lib/services/location/location_mock_data.dart
import 'package:tsuite/services/location/geocode_client.dart';
import 'package:tsuite/services/location/haversine.dart';
import 'package:tsuite/services/location/location_config.dart';
import 'package:tsuite/services/location/places_session_client.dart';

/// Offline Mumbai fixtures for [AppConstants.useMockData] development.
class LocationMockData {
  LocationMockData._();

  static const List<_MockPlace> _places = [
    _MockPlace(
      placeId: 'mock_andheri_west',
      primary: 'Andheri West',
      secondary: 'Mumbai, Maharashtra',
      latitude: 19.1364,
      longitude: 72.8277,
      line1: 'Andheri West',
      line2: 'Near Lokhandwala',
      city: 'Mumbai',
      state: 'Maharashtra',
      pincode: '400053',
    ),
    _MockPlace(
      placeId: 'mock_bandra_west',
      primary: 'Bandra West',
      secondary: 'Mumbai, Maharashtra',
      latitude: 19.0596,
      longitude: 72.8295,
      line1: 'Bandra West',
      line2: 'Linking Road',
      city: 'Mumbai',
      state: 'Maharashtra',
      pincode: '400050',
    ),
    _MockPlace(
      placeId: 'mock_powai',
      primary: 'Powai',
      secondary: 'Mumbai, Maharashtra',
      latitude: 19.1176,
      longitude: 72.9060,
      line1: 'Powai',
      line2: 'Hiranandani Gardens',
      city: 'Mumbai',
      state: 'Maharashtra',
      pincode: '400076',
    ),
    _MockPlace(
      placeId: 'mock_lower_parel',
      primary: 'Lower Parel',
      secondary: 'Mumbai, Maharashtra',
      latitude: 18.9935,
      longitude: 72.8305,
      line1: 'Lower Parel',
      line2: 'Senapati Bapat Marg',
      city: 'Mumbai',
      state: 'Maharashtra',
      pincode: '400013',
    ),
    _MockPlace(
      placeId: 'mock_thane',
      primary: 'Thane West',
      secondary: 'Thane, Maharashtra',
      latitude: 19.2183,
      longitude: 72.9781,
      line1: 'Thane West',
      line2: 'Gokhale Road',
      city: 'Thane',
      state: 'Maharashtra',
      pincode: '400601',
    ),
  ];

  static List<PlacePrediction> autocomplete(String query) {
    final q = query.trim().toLowerCase();
    if (q.length < LocationConfig.minAutocompleteQueryLength) {
      return const [];
    }
    return _places
        .where(
          (p) =>
              p.primary.toLowerCase().contains(q) ||
              p.secondary.toLowerCase().contains(q) ||
              p.city.toLowerCase().contains(q),
        )
        .map(
          (p) => PlacePrediction(
            placeId: p.placeId,
            primaryText: p.primary,
            secondaryText: p.secondary,
          ),
        )
        .toList();
  }

  static PlaceDetailsResult? details(String placeId) {
    for (final place in _places) {
      if (place.placeId != placeId) continue;
      return PlaceDetailsResult(
        placeId: place.placeId,
        latitude: place.latitude,
        longitude: place.longitude,
        formattedAddress:
            '${place.line1}, ${place.line2}, ${place.city}, ${place.state} ${place.pincode}',
        line1: place.line1,
        line2: place.line2,
        city: place.city,
        state: place.state,
        pincode: place.pincode,
      );
    }
    return null;
  }

  static ReverseGeocodeResult reverse({
    required double latitude,
    required double longitude,
  }) {
    _MockPlace nearest = _places.first;
    var best = double.infinity;
    for (final place in _places) {
      final d = distanceMeters(
        fromLat: latitude,
        fromLng: longitude,
        toLat: place.latitude,
        toLng: place.longitude,
      );
      if (d < best) {
        best = d;
        nearest = place;
      }
    }

    // Prefer hub defaults when far from fixtures (e.g. emulator US GPS).
    final withinHub = isWithinDeliveryRadius(
      latitude: latitude,
      longitude: longitude,
    );
    if (!withinHub) {
      return const ReverseGeocodeResult(
        latitude: LocationConfig.defaultLat,
        longitude: LocationConfig.defaultLng,
        formattedAddress: 'Andheri West, Mumbai, Maharashtra 400053',
        line1: 'Andheri West',
        line2: 'Mumbai Suburban',
        city: 'Mumbai',
        state: 'Maharashtra',
        pincode: '400053',
        placeId: 'mock_default_andheri',
      );
    }

    return ReverseGeocodeResult(
      latitude: latitude,
      longitude: longitude,
      formattedAddress:
          '${nearest.line1}, ${nearest.city}, ${nearest.state} ${nearest.pincode}',
      line1: nearest.line1,
      line2: nearest.line2,
      city: nearest.city,
      state: nearest.state,
      pincode: nearest.pincode,
      placeId: nearest.placeId,
    );
  }
}

class _MockPlace {
  const _MockPlace({
    required this.placeId,
    required this.primary,
    required this.secondary,
    required this.latitude,
    required this.longitude,
    required this.line1,
    required this.line2,
    required this.city,
    required this.state,
    required this.pincode,
  });

  final String placeId;
  final String primary;
  final String secondary;
  final double latitude;
  final double longitude;
  final String line1;
  final String line2;
  final String city;
  final String state;
  final String pincode;
}

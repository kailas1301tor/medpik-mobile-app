// lib/utils/helpers/forward_geocode_filter.dart
import 'package:medpik/services/location/haversine.dart';

/// Types that alone mean a country / continent match — too coarse for address pick.
const Set<String> _coarseOnlyGeocodeTypes = {
  'country',
  'continent',
};

/// Types that indicate a place useful for delivery pin selection.
const Set<String> _usefulForwardGeocodeTypes = {
  'street_address',
  'route',
  'intersection',
  'premise',
  'subpremise',
  'neighborhood',
  'sublocality',
  'sublocality_level_1',
  'sublocality_level_2',
  'locality',
  'postal_town',
  'postal_code',
  'administrative_area_level_1',
  'administrative_area_level_2',
  'administrative_area_level_3',
  'colloquial_area',
  'establishment',
  'point_of_interest',
  'airport',
  'park',
  'plus_code',
  'tourist_attraction',
};

bool isCoarseOnlyGeocodeTypes(List<String> types) {
  if (types.isEmpty) return false;
  final hasUseful = types.any(_usefulForwardGeocodeTypes.contains);
  if (hasUseful) return false;
  return types.any(_coarseOnlyGeocodeTypes.contains);
}

/// Keeps pick-list rows that are specific enough and inside the service area.
bool isUsefulForwardGeocodeResult({
  required List<String> types,
  required double latitude,
  required double longitude,
  required String state,
}) {
  if (isCoarseOnlyGeocodeTypes(types)) return false;
  if (isDeliveryState(state)) return true;
  return isWithinKeralaBoundingBox(
    latitude: latitude,
    longitude: longitude,
  );
}

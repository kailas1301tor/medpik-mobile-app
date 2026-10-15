// test/services/location/geocode_lru_cache_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/services/location/geocode_client.dart';

void main() {
  group('GeocodeLruCache forward list', () {
    late GeocodeLruCache cache;

    setUp(() => cache = GeocodeLruCache());

    const a = ReverseGeocodeResult(
      latitude: 10.52,
      longitude: 76.21,
      formattedAddress: 'Thrissur, Kerala',
      state: 'Kerala',
    );
    const b = ReverseGeocodeResult(
      latitude: 10.53,
      longitude: 76.22,
      formattedAddress: 'Thrissur Junction, Kerala',
      state: 'Kerala',
    );

    test('putList / getList returns full list for exact query key', () {
      final key = cache.keyForQuery('Malakka');
      cache.putList(key, [a, b]);

      final hit = cache.getList(key);
      expect(hit, isNotNull);
      expect(hit, hasLength(2));
      expect(hit!.first.formattedAddress, 'Thrissur, Kerala');
      expect(hit[1].formattedAddress, 'Thrissur Junction, Kerala');
    });

    test('different query keys do not collide', () {
      cache.putList(cache.keyForQuery('malakka'), [a]);
      expect(cache.getList(cache.keyForQuery('wadakkanchery')), isNull);
      expect(cache.getList(cache.keyForQuery('malakka')), hasLength(1));
    });

    test('query key is case-insensitive via keyForQuery', () {
      cache.putList(cache.keyForQuery('Malakka'), [a, b]);
      expect(cache.getList(cache.keyForQuery('malakka')), hasLength(2));
    });
  });
}

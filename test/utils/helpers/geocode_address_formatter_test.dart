// test/utils/helpers/geocode_address_formatter_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/utils/helpers/geocode_address_formatter.dart';

void main() {
  group('formatGeocodeDisplayAddress', () {
    test('strips leading plus code', () {
      expect(
        formatGeocodeDisplayAddress('J7HM+397, Malakka, Kerala 680589, India'),
        'Malakka, Kerala 680589, India',
      );
    });

    test('returns address unchanged when no plus code', () {
      const input = 'Thrissur, Kerala, India';
      expect(formatGeocodeDisplayAddress(input), input);
    });

    test('returns empty for empty input', () {
      expect(formatGeocodeDisplayAddress(''), '');
    });
  });
}

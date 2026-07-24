import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/src/address/model/address_save_response_model.dart';

void main() {
  group('AddressSaveResponse', () {
    test('parses nested results.data object', () {
      final response = AddressSaveResponse.fromJson({
        'message': 'Address saved',
        'results': {
          'data': {
            'id': 12,
            'full_name': 'Home',
            'phone_number': '9876543210',
            'address_line_1': 'Line 1',
            'city': 'Mumbai',
            'state': 'Maharashtra',
            'postal_code': '400076',
            'is_default': true,
          },
        },
      });

      expect(response.address?.id, 12);
      expect(response.address?.label, 'Home');
      expect(response.address?.isDefault, isTrue);
    });

    test('parses nested results.data list', () {
      final response = AddressSaveResponse.fromJson({
        'results': {
          'data': [
            {
              'id': 3,
              'full_name': 'Work',
              'address_line_1': 'Office',
              'city': 'Mumbai',
              'state': 'Maharashtra',
              'postal_code': '400001',
              'is_default': false,
            },
          ],
        },
      });

      expect(response.address?.id, 3);
      expect(response.address?.label, 'Work');
      expect(response.address?.isDefault, isFalse);
    });
  });
}

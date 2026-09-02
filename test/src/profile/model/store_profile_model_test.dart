import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/src/profile/model/store_profile_model.dart';

void main() {
  group('StoreProfileResponse', () {
    test('parses the results.data envelope from the live API', () {
      final response = StoreProfileResponse.fromJson({
        'message': 'Store Profile retrieved',
        'status': true,
        'results': {
          'data': {
            'id': 1,
            'support_phone': '+1234567890',
            'support_email': 'support@medpik.com',
            'updated_at': '2026-08-25T11:42:00.000Z',
          },
        },
      });

      expect(response.message, 'Store Profile retrieved');
      expect(response.status, isTrue);
      expect(response.data?.id, 1);
      expect(response.data?.supportPhone, '+1234567890');
      expect(response.data?.supportEmail, 'support@medpik.com');
      expect(response.data?.updatedAt, '2026-08-25T11:42:00.000Z');
      expect(response.data?.hasContact, isTrue);
    });

    test('keeps missing data nullable', () {
      final response = StoreProfileResponse.fromJson({
        'message': 'Store Profile retrieved',
        'results': {},
      });

      expect(response.data, isNull);
    });

    test('safely converts malformed and blank fields', () {
      final response = StoreProfileResponse.fromJson({
        'status': true,
        'results': {
          'data': {
            'id': 'invalid',
            'support_phone': '  ',
            'support_email': null,
            'updated_at': 42,
          },
        },
      });

      expect(response.status, isTrue);
      expect(response.data?.id, 0);
      expect(response.data?.supportPhone, isEmpty);
      expect(response.data?.supportEmail, isEmpty);
      expect(response.data?.updatedAt, '42');
      expect(response.data?.hasContact, isFalse);
    });
  });
}

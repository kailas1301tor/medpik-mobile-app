// test/order_detail_response_model_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:tsuite/src/orders/model/order_detail_response_model.dart';

void main() {
  group('OrderDetailResponse', () {
    test('parses single-object results.data into OrderModel', () {
      final response = OrderDetailResponse.fromJson({
        'message': 'Success',
        'results': {
          'data': {
            'id': 1,
            'order_id': 'ORD-1001',
            'status': 'pending',
            'total_amount': null,
            'created_at': '15 Jul 2026, 04:31 PM',
            'delivery_instructions': 'Leave at gate',
            'prescription_description': 'Take after food',
            'is_prescription_order': true,
            'customer_detail': {
              'country_code': '+91',
              'phone_number': '9876543210',
              'user_detail': {
                'first_name': 'Anita',
                'last_name': 'Sharma',
              },
            },
            'address_detail': {
              'id': 10,
              'full_name': 'Home',
              'address_line_1': '12 Palm Street',
              'city': 'Mumbai',
              'state': 'Maharashtra',
              'postal_code': '400076',
              'phone_number': '9999999999',
            },
            'items': [
              {
                'quantity': 2,
                'product_detail': {
                  'id': 5,
                  'name': 'Paracetamol',
                  'price': 40,
                  'image_url': 'https://cdn.example.com/p.png',
                },
              },
            ],
            'prescriptions': [
              {'image_url': 'https://cdn.example.com/rx.png'},
            ],
          },
        },
      });

      final order = response.order;
      expect(order, isNotNull);
      expect(order!.id, '1');
      expect(order.orderCode, 'ORD-1001');
      expect(order.hasKnownAmount, isFalse);
      expect(order.amount, 0);
      expect(order.customerName, 'Anita Sharma');
      expect(order.customerPhone, '+919876543210');
      expect(order.deliveryInstructions, 'Leave at gate');
      expect(order.prescriptionDescription, 'Take after food');
      expect(order.prescriptionImageUrls, ['https://cdn.example.com/rx.png']);
      expect(order.address.fullAddress, contains('12 Palm Street'));
      expect(order.createdAt.year, 2026);
      expect(order.createdAt.month, 7);
      expect(order.createdAt.day, 15);
      expect(order.createdAt.hour, 16);
      expect(order.createdAt.minute, 31);
    });

    test('falls back to address phone when customer phone is missing', () {
      final order = OrderDetailResponse.fromJson({
        'results': {
          'data': {
            'id': '22',
            'status': 'delivered',
            'created_at': '2026-07-15T16:31:00.000Z',
            'customer_detail': {
              'user_detail': {'first_name': 'Ravi', 'last_name': ''},
            },
            'address_detail': {
              'id': 1,
              'label': 'Office',
              'line1': 'Tower A',
              'city': 'Pune',
              'state': 'MH',
              'pincode': '411001',
              'phone_number': '8888777766',
            },
            'items': const [],
            'prescriptions': const [],
          },
        },
      }).order;

      expect(order, isNotNull);
      expect(order!.customerName, 'Ravi');
      expect(order.customerPhone, '8888777766');
      expect(order.createdAt.isUtc, isTrue);
    });
  });
}

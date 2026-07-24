// test/order_detail_response_model_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/src/orders/model/order_detail_response_model.dart';

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

    test('parses new bill object, Bill Sent status, and item-level pricing', () {
      final response = OrderDetailResponse.fromJson({
        'message': 'Success',
        'results': {
          'data': {
            'id': 8,
            'order_id': 'MPK260717000008',
            'status': 'Bill Sent',
            'total_amount': null,
            'is_prescription_order': false,
            'delivery_instructions': 'placeoutside',
            'created_at': '17 Jul 2026, 12:59 PM',
            'customer_detail': {
              'id': 2,
              'country_code': '+91',
              'phone_number': '8943936486',
              'user_detail': {
                'id': 2,
                'first_name': '',
                'last_name': '',
              },
            },
            'address_detail': {
              'id': 4,
              'full_name': 'work',
              'phone_number': '92424242424',
              'address_line_1': 'Powai',
              'address_line_2': 'Hiranandani Gardens',
              'city': 'Mumbai',
              'state': 'Maharashtra',
              'postal_code': '400076',
            },
            'items': [
              {
                'id': 12,
                'quantity': 3,
                'price': '10.00',
                'total_price': '33.00',
                'status': 'Available',
                'expiry_date': '2026-07-21',
                'sgst': '5.00',
                'cgst': '5.00',
                'product_detail': {
                  'id': 12,
                  'name': 'DIGENE GEL MINT 200 ML+LEMON FIZZ',
                  'rate': '0.00',
                  'image': 'https://example.com/p.png',
                  'is_otc': true,
                },
              },
            ],
            'bill': {
              'subtotal': '240.00',
              'delivery_fee': '10.00',
              'tax': '0.00',
              'total': '250.00',
              'is_sent_to_customer': true,
              'bill_pdf': null,
            },
          },
        },
      });

      final order = response.order;
      expect(order, isNotNull);
      expect(order!.status, OrderStatus.awaitingBillApproval);
      expect(order.statusRaw, 'Bill Sent');
      expect(order.hasKnownAmount, isTrue);
      expect(order.amount, 250);
      expect(order.customerName, 'work');
      expect(order.customerPhone, '+918943936486');

      final bill = order.billBreakdown!;
      expect(bill.itemTotal, 240);
      expect(bill.deliveryCharges, 10);
      expect(bill.tax, 0);
      expect(bill.grandTotal, 250);
      expect(bill.isSentToCustomer, isTrue);
      expect(bill.billPdfUrl, isNull);
      expect(order.hasBillPdf, isFalse);

      final item = order.items.first;
      expect(item.unitPrice, 10);
      expect(item.totalPrice, 33);
      expect(item.lineTotal, 33);
      expect(item.status, 'Available');
      expect(item.expiryDate, '2026-07-21');
      expect(item.sgst, 5);
      expect(item.cgst, 5);
    });

    test('parses bill_pdf URL when present', () {
      final order = OrderDetailResponse.fromJson({
        'results': {
          'data': {
            'id': '10',
            'status': 'Bill Sent',
            'total_amount': null,
            'created_at': '17 Jul 2026, 12:59 PM',
            'address_detail': {
              'id': 1,
              'full_name': 'Home',
              'address_line_1': '12 Palm Street',
              'city': 'Mumbai',
              'state': 'Maharashtra',
              'postal_code': '400076',
            },
            'items': const [],
            'bill': {
              'subtotal': '100.00',
              'delivery_fee': '10.00',
              'tax': '0.00',
              'total': '110.00',
              'is_sent_to_customer': true,
              'bill_pdf': 'https://example.com/bill.pdf',
            },
          },
        },
      }).order;

      expect(order, isNotNull);
      expect(order!.billBreakdown?.billPdfUrl, 'https://example.com/bill.pdf');
      expect(order.hasBillPdf, isTrue);
      expect(order.billPdfUrl, 'https://example.com/bill.pdf');
    });

    test('parses legacy bill_breakdown shape', () {
      final order = OrderDetailResponse.fromJson({
        'results': {
          'data': {
            'id': '99',
            'status': 'bill_generated',
            'total_amount': 1245,
            'created_at': '2026-07-15T16:31:00.000Z',
            'address_detail': {
              'id': 1,
              'full_name': 'Home',
              'address_line_1': '12 Palm Street',
              'city': 'Mumbai',
              'state': 'Maharashtra',
              'postal_code': '400076',
            },
            'items': const [],
            'bill_breakdown': {
              'item_total': 1185,
              'delivery_charges': 40,
              'packaging_charges': 20,
            },
          },
        },
      }).order;

      expect(order, isNotNull);
      final bill = order!.billBreakdown!;
      expect(bill.itemTotal, 1185);
      expect(bill.deliveryCharges, 40);
      expect(bill.packagingCharges, 20);
      expect(bill.tax, 0);
      expect(bill.grandTotal, 1245);
      expect(bill.isSentToCustomer, isFalse);
    });

    test('parses Payment Received status, bill, prescriptions, and image', () {
      final response = OrderDetailResponse.fromJson({
        'message': 'Success',
        'results': {
          'data': {
            'id': 9,
            'order_id': 'MPK260720000009',
            'status': 'Payment Received',
            'total_amount': '100.00',
            'is_prescription_order': true,
            'prescription_description': '',
            'delivery_instructions': '',
            'created_at': '20 Jul 2026, 11:36 AM',
            'customer_detail': {
              'id': 2,
              'country_code': '+91',
              'phone_number': '8943936486',
              'user_detail': {
                'id': 2,
                'first_name': '',
                'last_name': '',
              },
            },
            'address_detail': {
              'id': 4,
              'full_name': 'work',
              'phone_number': '92424242424',
              'address_line_1': 'Powai',
              'address_line_2': 'Hiranandani Gardens',
              'city': 'Mumbai',
              'state': 'Maharashtra',
              'postal_code': '400076',
            },
            'items': [
              {
                'id': 17,
                'quantity': 1,
                'price': '0.00',
                'total_price': '0.00',
                'status': 'Available',
                'product_detail': {
                  'id': 12,
                  'name': 'DIGENE GEL MINT 200 ML+LEMON FIZZ',
                  'pack_size': '5GM',
                  'rate': '0.00',
                  'image':
                      'https://medpik-backend.onrender.com/media/products/Screenshot_2026-07-15_125854.png',
                  'is_otc': true,
                },
              },
            ],
            'prescriptions': [
              {
                'id': 5,
                'image':
                    'https://medpik-backend.onrender.com/media/prescriptions/order_9/rx1.jpg',
                'image_url':
                    'https://medpik-backend.onrender.com/media/prescriptions/order_9/rx1.jpg',
              },
              {
                'id': 6,
                'image':
                    'https://medpik-backend.onrender.com/media/prescriptions/order_9/rx2.jpg',
                'image_url':
                    'https://medpik-backend.onrender.com/media/prescriptions/order_9/rx2.jpg',
              },
            ],
            'bill': {
              'subtotal': '0.00',
              'delivery_fee': '10.00',
              'tax': '0.00',
              'total': '10.00',
              'is_sent_to_customer': true,
              'bill_pdf': null,
            },
          },
        },
      });

      final order = response.order;
      expect(order, isNotNull);
      expect(order!.status, OrderStatus.paymentCompleted);
      expect(order.statusRaw, 'Payment Received');
      expect(order.amount, 100);
      expect(order.displayGrandTotal, 10);
      expect(order.hasKnownAmount, isTrue);

      final bill = order.billBreakdown!;
      expect(bill.itemTotal, 0);
      expect(bill.deliveryCharges, 10);
      expect(bill.tax, 0);
      expect(bill.grandTotal, 10);
      expect(bill.isSentToCustomer, isTrue);

      expect(order.prescriptionImageUrls.length, 2);
      expect(
        order.prescriptionImageUrls.first,
        contains('medpik-backend.onrender.com/media/prescriptions'),
      );

      final item = order.items.first;
      expect(item.lineTotal, 0);
      expect(item.product.imageUrl, isNotEmpty);
      expect(
        item.product.imageUrl,
        contains('medpik-backend.onrender.com/media/products'),
      );
    });
  });
}

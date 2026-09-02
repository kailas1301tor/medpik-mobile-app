// test/order_payment_response_model_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/src/orders/model/order_payment_create_response_model.dart';
import 'package:medpik/src/orders/model/order_payment_submit_response_model.dart';

void main() {
  group('OrderPaymentCreateResponse', () {
    test('parses checkout data envelope', () {
      final response = OrderPaymentCreateResponse.fromJson({
        'message': 'Success',
        'results': {
          'data': {
            'razorpay_key': 'rzp_test_TGUKzSNw33Iw7s',
            'razorpay_order_id': 'order_TGVUbWUoZhxXVG',
            'amount': 10000,
            'currency': 'INR',
            'name': 'medpik',
            'description': 'Order MPK260722000011',
            'prefill': {
              'name': '+919876543210',
              'email': '',
              'contact': '9876543210',
            },
          },
        },
      });

      final checkout = response.checkoutData;
      expect(response.message, 'Success');
      expect(checkout, isNotNull);
      expect(checkout!.razorpayKey, 'rzp_test_TGUKzSNw33Iw7s');
      expect(checkout.razorpayOrderId, 'order_TGVUbWUoZhxXVG');
      expect(checkout.amount, 10000);
      expect(checkout.currency, 'INR');
      expect(checkout.prefill.contact, '9876543210');
    });

    test('supports key_id alias for razorpay key', () {
      final response = OrderPaymentCreateResponse.fromJson({
        'message': 'ok',
        'results': {
          'data': {
            'key_id': 'rzp_test_alias',
            'order_id': 'order_alias',
            'amount': 100,
          },
        },
      });

      expect(response.checkoutData?.razorpayKey, 'rzp_test_alias');
      expect(response.checkoutData?.razorpayOrderId, 'order_alias');
    });
  });

  group('OrderPaymentSubmitResponse', () {
    test('parses submit success envelope', () {
      final response = OrderPaymentSubmitResponse.fromJson({
        'message': 'Payment information updated successfully',
        'results': {},
      });

      expect(response.message, 'Payment information updated successfully');
      expect(response.results, isA<OrderPaymentSubmitResults>());
    });
  });
}

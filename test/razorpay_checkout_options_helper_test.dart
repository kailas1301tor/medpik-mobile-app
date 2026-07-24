// test/razorpay_checkout_options_helper_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/src/orders/model/order_payment_create_response_model.dart';
import 'package:medpik/utils/helpers/razorpay_checkout_options_helper.dart';

void main() {
  group('buildRazorpayCheckoutOptions', () {
    test('maps checkout data to Razorpay options', () {
      const data = OrderPaymentCheckoutData(
        razorpayKey: 'rzp_test_key',
        razorpayOrderId: 'order_123',
        amount: 25000,
        currency: 'INR',
        name: 'Medpik',
        description: 'Order payment',
        prefill: OrderPaymentPrefillData(
          name: 'Jane Doe',
          email: 'jane@example.com',
          contact: '8888888888',
        ),
      );

      final options = buildRazorpayCheckoutOptions(data);

      expect(options['key'], 'rzp_test_key');
      expect(options['order_id'], 'order_123');
      expect(options['amount'], 25000);
      expect(options['currency'], 'INR');
      expect(options['name'], 'Medpik');
      expect(options['description'], 'Order payment');
      expect(options['prefill'], {
        'name': 'Jane Doe',
        'email': 'jane@example.com',
        'contact': '8888888888',
      });
      expect(options['method'], {
        'card': true,
        'upi': true,
        'netbanking': false,
        'wallet': false,
        'emi': false,
        'paylater': false,
      });
    });

    test('omits empty prefill fields', () {
      const data = OrderPaymentCheckoutData(
        razorpayKey: 'rzp_test_key',
        razorpayOrderId: 'order_123',
        amount: 100,
      );

      final options = buildRazorpayCheckoutOptions(data);

      expect(options.containsKey('prefill'), isFalse);
    });
  });
}

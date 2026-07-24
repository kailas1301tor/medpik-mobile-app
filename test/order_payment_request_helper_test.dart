// test/order_payment_request_helper_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/utils/helpers/order_payment_request_helper.dart';

void main() {
  group('buildPaymentInitBody', () {
    test('builds Razorpay init request', () {
      expect(
        buildPaymentInitBody(orderId: 10),
        {
          'order_id': 10,
          'payment_method': 'Razorpay',
        },
      );
    });
  });

  group('buildCodPaymentBody', () {
    test('builds COD request with Pending status', () {
      expect(
        buildCodPaymentBody(orderId: 10),
        {
          'order_id': 10,
          'payment_method': 'COD',
          'payment_status': 'Pending',
        },
      );
    });
  });

  group('buildRazorpaySuccessPaymentBody', () {
    test('builds success submit request', () {
      final body = buildRazorpaySuccessPaymentBody(
        orderId: 10,
        razorpayOrderId: 'order_abc',
        razorpayPaymentId: 'pay_abc',
        razorpaySignature: 'sig_abc',
      );

      expect(body['order_id'], 10);
      expect(body['payment_method'], 'Razorpay');
      expect(body['payment_status'], 'Success');
      expect(body['razorpay_order_id'], 'order_abc');
      expect(body['razorpay_payment_id'], 'pay_abc');
      expect(body['razorpay_signature'], 'sig_abc');
      expect(body['payment_response_data'], isEmpty);
    });
  });

  group('buildRazorpayFailedPaymentBody', () {
    test('builds failed submit request', () {
      final body = buildRazorpayFailedPaymentBody(
        orderId: 10,
        razorpayOrderId: 'order_abc',
        paymentResponseData: const {'code': 2},
      );

      expect(body['order_id'], 10);
      expect(body['payment_method'], 'Razorpay');
      expect(body['payment_status'], 'Failed');
      expect(body['razorpay_order_id'], 'order_abc');
      expect(body['razorpay_payment_id'], '');
      expect(body['razorpay_signature'], '');
      expect(body['payment_response_data'], {'code': 2});
    });
  });
}

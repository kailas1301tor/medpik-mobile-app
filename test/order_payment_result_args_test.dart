// test/order_payment_result_args_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/src/orders/model/order_payment_outcome.dart';
import 'package:medpik/src/orders/model/order_payment_result_args.dart';

void main() {
  group('OrderPaymentFailureContent', () {
    test('uses cancelled copy for cancelled outcome', () {
      final content = OrderPaymentFailureContent.fromArgs(
        const OrderPaymentResultArgs(
          orderId: 'MPK1001',
          outcome: OrderPaymentOutcome.cancelled,
        ),
      );

      expect(content.title, Strings.paymentCancelledTitle);
      expect(content.message, Strings.paymentCancelledMessage);
    });

    test('uses failure copy for failure outcome', () {
      final content = OrderPaymentFailureContent.fromArgs(
        const OrderPaymentResultArgs(
          orderId: 'MPK1001',
          outcome: OrderPaymentOutcome.failure,
        ),
      );

      expect(content.title, Strings.paymentFailureTitle);
      expect(content.message, Strings.paymentFailureMessage);
    });

    test('prefers custom message when provided', () {
      const customMessage = 'Bank declined the transaction';

      final content = OrderPaymentFailureContent.fromArgs(
        const OrderPaymentResultArgs(
          orderId: 'MPK1001',
          outcome: OrderPaymentOutcome.failure,
          message: customMessage,
        ),
      );

      expect(content.message, customMessage);
    });
  });
}

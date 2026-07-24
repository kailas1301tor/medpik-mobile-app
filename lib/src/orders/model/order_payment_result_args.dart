// lib/src/orders/model/order_payment_result_args.dart
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/src/orders/model/order_payment_outcome.dart';

class OrderPaymentResultArgs {
  const OrderPaymentResultArgs({
    required this.orderId,
    this.outcome = OrderPaymentOutcome.success,
    this.message = '',
  });

  final String orderId;
  final OrderPaymentOutcome outcome;
  final String message;
}

class OrderPaymentFailureContent {
  const OrderPaymentFailureContent({
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  factory OrderPaymentFailureContent.fromArgs(OrderPaymentResultArgs args) {
    if (args.outcome == OrderPaymentOutcome.cancelled) {
      return OrderPaymentFailureContent(
        title: Strings.paymentCancelledTitle,
        message: args.message.isNotEmpty
            ? args.message
            : Strings.paymentCancelledMessage,
      );
    }
    return OrderPaymentFailureContent(
      title: Strings.paymentFailureTitle,
      message:
          args.message.isNotEmpty ? args.message : Strings.paymentFailureMessage,
    );
  }
}

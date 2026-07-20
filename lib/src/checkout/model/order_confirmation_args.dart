// lib/src/checkout/model/order_confirmation_args.dart
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';

class OrderConfirmationArgs {
  const OrderConfirmationArgs({
    required this.orderId,
    required this.source,
  });

  final String orderId;
  final OrderSubmissionSource source;
}

class OrderConfirmationContent {
  const OrderConfirmationContent({
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  factory OrderConfirmationContent.forSource(OrderSubmissionSource source) {
    return switch (source) {
      OrderSubmissionSource.medicineCart => const OrderConfirmationContent(
          title: Strings.orderSubmittedSuccessTitle,
          message: Strings.orderSubmittedSuccessMessage,
        ),
      OrderSubmissionSource.prescription => const OrderConfirmationContent(
          title: Strings.prescriptionOrderSubmittedSuccessTitle,
          message: Strings.prescriptionOrderSubmittedSuccessMessage,
        ),
    };
  }
}

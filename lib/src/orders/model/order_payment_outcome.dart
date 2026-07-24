// lib/src/orders/model/order_payment_outcome.dart
enum OrderPaymentOutcome {
  success,
  failure,
  cancelled,
}

class OrderPaymentResult {
  const OrderPaymentResult({
    required this.outcome,
    this.message = '',
  });

  final OrderPaymentOutcome outcome;
  final String message;
}

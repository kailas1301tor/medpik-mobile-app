// lib/src/orders/model/order_payment_submit_response_model.dart
import 'package:medpik/utils/helpers/safe_converters.dart';

class OrderPaymentSubmitResponse {
  const OrderPaymentSubmitResponse({
    required this.results,
    this.message = '',
    this.status = true,
  });

  final OrderPaymentSubmitResults results;
  final String message;
  final bool status;

  factory OrderPaymentSubmitResponse.fromJson(Map<String, dynamic> json) {
    final hasStatus = json.containsKey('status');
    return OrderPaymentSubmitResponse(
      message: convertToString(json['message']),
      status: hasStatus ? convertToBool(json['status']) : true,
      results: OrderPaymentSubmitResults.fromJson(convertToMap(json['results'])),
    );
  }
}

class OrderPaymentSubmitResults {
  const OrderPaymentSubmitResults();

  factory OrderPaymentSubmitResults.fromJson(Map<String, dynamic> json) =>
      const OrderPaymentSubmitResults();
}

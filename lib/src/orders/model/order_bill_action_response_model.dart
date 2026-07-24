// lib/src/orders/model/order_bill_action_response_model.dart
import 'package:medpik/utils/helpers/safe_converters.dart';

class OrderBillActionResponse {
  const OrderBillActionResponse({
    required this.results,
    this.message = '',
  });

  final OrderBillActionResults results;
  final String message;

  factory OrderBillActionResponse.fromJson(Map<String, dynamic> json) =>
      OrderBillActionResponse(
        message: convertToString(json['message']),
        results: OrderBillActionResults.fromJson(convertToMap(json['results'])),
      );
}

class OrderBillActionResults {
  const OrderBillActionResults();

  factory OrderBillActionResults.fromJson(Map<String, dynamic> json) =>
      const OrderBillActionResults();
}

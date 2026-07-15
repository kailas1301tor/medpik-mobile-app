// lib/src/orders/model/orders_response_model.dart
import 'package:tsuite/data/models/order_model.dart';
import 'package:tsuite/utils/helpers/safe_converters.dart';

class OrdersResponse {
  const OrdersResponse({
    required this.results,
    this.message = '',
  });

  final OrdersResults results;
  final String message;

  List<OrderModel> get orders => results.data;

  factory OrdersResponse.fromJson(Map<String, dynamic> json) => OrdersResponse(
        message: convertToString(json['message']),
        results: OrdersResults.fromJson(convertToMap(json['results'])),
      );
}

class OrdersResults {
  const OrdersResults({this.data = const []});

  final List<OrderModel> data;

  factory OrdersResults.fromJson(Map<String, dynamic> json) => OrdersResults(
        data: convertToList(json['data'])
            .map((e) => OrderModel.fromJson(convertToMap(e)))
            .toList(),
      );
}

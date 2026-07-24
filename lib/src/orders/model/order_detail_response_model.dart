// lib/src/orders/model/order_detail_response_model.dart
import 'package:medpik/data/models/order_model.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';

class OrderDetailResponse {
  const OrderDetailResponse({
    required this.results,
    this.message = '',
  });

  final OrderDetailResults results;
  final String message;

  OrderModel? get order => results.data;

  factory OrderDetailResponse.fromJson(Map<String, dynamic> json) =>
      OrderDetailResponse(
        message: convertToString(json['message']),
        results: OrderDetailResults.fromJson(convertToMap(json['results'])),
      );
}

class OrderDetailResults {
  const OrderDetailResults({this.data});

  final OrderModel? data;

  factory OrderDetailResults.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    if (raw == null) {
      return const OrderDetailResults();
    }
    if (raw is List) {
      final list = convertToList(raw);
      if (list.isEmpty) return const OrderDetailResults();
      return OrderDetailResults(
        data: OrderModel.fromJson(convertToMap(list.first)),
      );
    }
    return OrderDetailResults(
      data: OrderModel.fromJson(convertToMap(raw)),
    );
  }
}

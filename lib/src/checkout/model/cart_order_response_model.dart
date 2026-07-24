// lib/src/checkout/model/cart_order_response_model.dart
import 'package:medpik/utils/helpers/safe_converters.dart';

class CartOrderResponse {
  const CartOrderResponse({
    required this.results,
    this.message = '',
  });

  final CartOrderResults results;
  final String message;

  String get orderId {
    final raw = results.data?.orderId;
    if (raw == null || raw.isEmpty) return '';
    return raw;
  }

  factory CartOrderResponse.fromJson(Map<String, dynamic> json) =>
      CartOrderResponse(
        message: convertToString(json['message']),
        results: CartOrderResults.fromJson(convertToMap(json['results'])),
      );
}

class CartOrderResults {
  const CartOrderResults({this.data});

  final CartOrderData? data;

  factory CartOrderResults.fromJson(Map<String, dynamic> json) =>
      CartOrderResults(
        data: json['data'] == null
            ? null
            : CartOrderData.fromJson(convertToMap(json['data'])),
      );
}

class CartOrderData {
  const CartOrderData({required this.orderId});

  final String orderId;

  factory CartOrderData.fromJson(Map<String, dynamic> json) {
    final raw = json['order_id'] ?? json['id'];
    if (raw == null) {
      return const CartOrderData(orderId: '');
    }
    return CartOrderData(orderId: convertToString(raw));
  }
}

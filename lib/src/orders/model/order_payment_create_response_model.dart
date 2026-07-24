// lib/src/orders/model/order_payment_create_response_model.dart
import 'package:medpik/utils/helpers/safe_converters.dart';

class OrderPaymentCreateResponse {
  const OrderPaymentCreateResponse({
    required this.results,
    this.message = '',
    this.status = true,
  });

  final OrderPaymentCreateResults results;
  final String message;
  final bool status;

  OrderPaymentCheckoutData? get checkoutData => results.data;

  factory OrderPaymentCreateResponse.fromJson(Map<String, dynamic> json) {
    final hasStatus = json.containsKey('status');
    return OrderPaymentCreateResponse(
      message: convertToString(json['message']),
      status: hasStatus ? convertToBool(json['status']) : true,
      results: OrderPaymentCreateResults.fromJson(convertToMap(json['results'])),
    );
  }
}

class OrderPaymentCreateResults {
  const OrderPaymentCreateResults({this.data});

  final OrderPaymentCheckoutData? data;

  factory OrderPaymentCreateResults.fromJson(Map<String, dynamic> json) =>
      OrderPaymentCreateResults(
        data: json['data'] == null
            ? null
            : OrderPaymentCheckoutData.fromJson(convertToMap(json['data'])),
      );
}

class OrderPaymentCheckoutData {
  const OrderPaymentCheckoutData({
    required this.razorpayKey,
    required this.razorpayOrderId,
    required this.amount,
    this.currency = 'INR',
    this.name = '',
    this.description = '',
    this.prefill = const OrderPaymentPrefillData(),
  });

  final String razorpayKey;
  final String razorpayOrderId;
  final int amount;
  final String currency;
  final String name;
  final String description;
  final OrderPaymentPrefillData prefill;

  factory OrderPaymentCheckoutData.fromJson(Map<String, dynamic> json) {
    final key = convertToString(json['razorpay_key']).trim();
    final fallbackKey = convertToString(json['key_id']).trim();
    return OrderPaymentCheckoutData(
      razorpayKey: key.isNotEmpty ? key : fallbackKey,
      razorpayOrderId: convertToString(
        json['razorpay_order_id'] ?? json['order_id'],
      ),
      amount: convertToInt(json['amount']),
      currency: _nonEmptyOr(convertToString(json['currency']), 'INR'),
      name: convertToString(json['name']),
      description: convertToString(json['description']),
      prefill: json['prefill'] == null
          ? const OrderPaymentPrefillData()
          : OrderPaymentPrefillData.fromJson(convertToMap(json['prefill'])),
    );
  }
}

class OrderPaymentPrefillData {
  const OrderPaymentPrefillData({
    this.name = '',
    this.email = '',
    this.contact = '',
  });

  final String name;
  final String email;
  final String contact;

  factory OrderPaymentPrefillData.fromJson(Map<String, dynamic> json) =>
      OrderPaymentPrefillData(
        name: convertToString(json['name']),
        email: convertToString(json['email']),
        contact: convertToString(json['contact']),
      );
}

String _nonEmptyOr(String value, String fallback) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? fallback : trimmed;
}

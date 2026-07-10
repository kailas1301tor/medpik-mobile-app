// lib/data/models/order_model.dart
import 'package:tsuite/data/models/address_model.dart';
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/utils/helpers/safe_converters.dart';

class OrderItemModel {
  const OrderItemModel({
    required this.product,
    required this.quantity,
  });

  final ProductModel product;
  final int quantity;

  double get lineTotal => product.price * quantity;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => OrderItemModel(
        product: ProductModel.fromJson(convertToMap(json['product'])),
        quantity: convertToInt(json['quantity']),
      );
}

class OrderModel {
  const OrderModel({
    required this.id,
    required this.items,
    required this.amount,
    required this.status,
    required this.address,
    required this.createdAt,
    this.etaText,
    this.hasPrescription = false,
  });

  final String id;
  final List<OrderItemModel> items;
  final double amount;
  final OrderStatus status;
  final AddressModel address;
  final DateTime createdAt;
  final String? etaText;
  final bool hasPrescription;

  bool get isActive =>
      status != OrderStatus.delivered && status != OrderStatus.cancelled;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: convertToString(json['id']),
        items: convertToList(json['items'])
            .map((e) => OrderItemModel.fromJson(convertToMap(e)))
            .toList(),
        amount: convertToDouble(json['amount']),
        status: _parseStatus(convertToString(json['status'])),
        address: AddressModel.fromJson(convertToMap(json['address'])),
        createdAt: DateTime.tryParse(convertToString(json['created_at'])) ??
            DateTime.now(),
        etaText: convertToString(json['eta_text']),
        hasPrescription: convertToBool(json['has_prescription']),
      );

  static OrderStatus _parseStatus(String value) {
    return switch (value.toLowerCase()) {
      'confirmed' => OrderStatus.confirmed,
      'packed' => OrderStatus.packed,
      'outfordelivery' || 'out_for_delivery' => OrderStatus.outForDelivery,
      'delivered' => OrderStatus.delivered,
      'cancelled' => OrderStatus.cancelled,
      _ => OrderStatus.placed,
    };
  }
}

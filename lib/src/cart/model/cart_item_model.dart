// lib/src/cart/model/cart_item_model.dart
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/utils/helpers/safe_converters.dart';

class CartItemModel {
  const CartItemModel({
    required this.id,
    required this.product,
    required this.quantity,
  });

  /// Cart line id from API (`items[].id`). Used for DELETE.
  final int id;

  final ProductModel product;
  final int quantity;

  double get lineTotal => product.price * quantity;

  CartItemModel copyWith({
    int? id,
    ProductModel? product,
    int? quantity,
  }) =>
      CartItemModel(
        id: id ?? this.id,
        product: product ?? this.product,
        quantity: quantity ?? this.quantity,
      );

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final productJson = json['product_detail'] ?? json['product'];
    return CartItemModel(
      id: convertToInt(json['id']),
      product: ProductModel.fromJson(convertToMap(productJson)),
      quantity: convertToInt(json['quantity']),
    );
  }
}

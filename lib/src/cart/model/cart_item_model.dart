// lib/src/cart/model/cart_item_model.dart
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/utils/helpers/safe_converters.dart';

class CartItemModel {
  const CartItemModel({
    required this.product,
    required this.quantity,
  });

  final ProductModel product;
  final int quantity;

  double get lineTotal => product.price * quantity;

  CartItemModel copyWith({int? quantity}) => CartItemModel(
        product: product,
        quantity: quantity ?? this.quantity,
      );

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        product: ProductModel.fromJson(convertToMap(json['product'])),
        quantity: convertToInt(json['quantity']),
      );
}

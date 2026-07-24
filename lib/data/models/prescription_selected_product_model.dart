// lib/data/models/prescription_selected_product_model.dart
import 'package:medpik/data/models/product_model.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';

class PrescriptionSelectedProductModel {
  const PrescriptionSelectedProductModel({
    required this.product,
    required this.quantity,
  });

  final ProductModel product;
  final int quantity;

  PrescriptionSelectedProductModel copyWith({
    ProductModel? product,
    int? quantity,
  }) => PrescriptionSelectedProductModel(
        product: product ?? this.product,
        quantity: quantity ?? this.quantity,
      );

  factory PrescriptionSelectedProductModel.fromJson(
    Map<String, dynamic> json,
  ) => PrescriptionSelectedProductModel(
        product: ProductModel.fromJson(convertToMap(json['product'])),
        quantity: convertToInt(json['quantity'], defValue: 1),
      );

  Map<String, dynamic> toJson() => {
        'product': {
          'id': product.id,
          'name': product.name,
          'category': product.category,
          'price': product.price,
          'image_url': product.imageUrl,
          'requires_prescription': product.requiresPrescription,
          'description': product.description,
          'mrp': product.mrp,
          'discount_percent': product.discountPercent,
          'pack_size': product.packSize,
        },
        'quantity': quantity,
      };
}

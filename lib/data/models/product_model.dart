// lib/data/models/product_model.dart
import 'package:tsuite/utils/helpers/safe_converters.dart';

class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.requiresPrescription,
    this.description = '',
    this.mrp,
    this.discountPercent,
    this.packSize = '',
  });

  final int id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final bool requiresPrescription;
  final String description;
  final double? mrp;
  final int? discountPercent;
  final String packSize;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: convertToInt(json['id']),
        name: convertToString(json['name']),
        category: convertToString(json['category']),
        price: convertToDouble(json['price']),
        imageUrl: convertToString(json['image_url']),
        requiresPrescription: convertToBool(json['requires_prescription']),
        description: convertToString(json['description']),
        mrp: json['mrp'] == null ? null : convertToDouble(json['mrp']),
        discountPercent: json['discount_percent'] == null
            ? null
            : convertToInt(json['discount_percent']),
        packSize: convertToString(json['pack_size']),
      );
}

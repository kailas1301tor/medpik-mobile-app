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
    this.manufacturerName = '',
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
  final String manufacturerName;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final categoryDetail = convertToMap(json['category_detail']);
    final manufacturerDetail = convertToMap(json['manufacturer_detail']);

    final categoryDetailName = convertToString(categoryDetail['name']);
    final rawCategory = json['category'];
    final category = categoryDetailName.isNotEmpty
        ? categoryDetailName
        : rawCategory is String
            ? convertToString(rawCategory)
            : '';

    final imageUrl = convertToString(json['image_url']).isNotEmpty
        ? convertToString(json['image_url'])
        : convertToString(json['image']);

    final price = json['rate'] != null
        ? convertToDouble(json['rate'])
        : convertToDouble(json['price']);

    final requiresPrescription = json.containsKey('is_otc')
        ? !convertToBool(json['is_otc'])
        : convertToBool(json['requires_prescription']);

    final manufacturerName =
        convertToString(json['manufacturer_name']).isNotEmpty
            ? convertToString(json['manufacturer_name'])
            : convertToString(manufacturerDetail['name']);

    return ProductModel(
      id: convertToInt(json['id']),
      name: convertToString(json['name']),
      category: category,
      price: price,
      imageUrl: imageUrl,
      requiresPrescription: requiresPrescription,
      description: convertToString(json['description']),
      mrp: json['mrp'] == null ? null : convertToDouble(json['mrp']),
      discountPercent: json['discount_percent'] == null
          ? null
          : convertToInt(json['discount_percent']),
      packSize: convertToString(json['pack_size']),
      manufacturerName: manufacturerName,
    );
  }
}

// lib/data/models/category_model.dart
import 'package:medpik/utils/helpers/safe_converters.dart';

class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    this.iconKey = '',
    this.imageUrl = '',
  });

  final int id;
  final String name;
  final String iconKey;
  final String imageUrl;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final imageUrl = convertToString(json['image_url']).isNotEmpty
        ? convertToString(json['image_url'])
        : convertToString(json['image']);
    return CategoryModel(
      id: convertToInt(json['id']),
      name: convertToString(json['name']),
      iconKey: convertToString(json['icon_key']),
      imageUrl: imageUrl,
    );
  }
}

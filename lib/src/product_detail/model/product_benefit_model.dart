// lib/src/product_detail/model/product_benefit_model.dart
import 'package:tsuite/utils/helpers/safe_converters.dart';

class ProductBenefitModel {
  const ProductBenefitModel({
    required this.title,
    required this.description,
    required this.iconKey,
  });

  final String title;
  final String description;
  final String iconKey;

  factory ProductBenefitModel.fromJson(Map<String, dynamic> json) =>
      ProductBenefitModel(
        title: convertToString(json['title']),
        description: convertToString(json['description']),
        iconKey: convertToString(json['icon_key']),
      );
}

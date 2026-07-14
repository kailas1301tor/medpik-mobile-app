// lib/src/product_detail/model/product_trust_badge_model.dart
import 'package:tsuite/utils/helpers/safe_converters.dart';

class ProductTrustBadgeModel {
  const ProductTrustBadgeModel({
    required this.title,
    required this.subtitle,
    required this.iconKey,
  });

  final String title;
  final String subtitle;
  final String iconKey;

  factory ProductTrustBadgeModel.fromJson(Map<String, dynamic> json) =>
      ProductTrustBadgeModel(
        title: convertToString(json['title']),
        subtitle: convertToString(json['subtitle']),
        iconKey: convertToString(json['icon_key']),
      );
}

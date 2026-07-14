// lib/src/product_detail/model/product_detail_model.dart
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/src/product_detail/model/product_benefit_model.dart';
import 'package:tsuite/src/product_detail/model/product_trust_badge_model.dart';
import 'package:tsuite/utils/helpers/safe_converters.dart';

class ProductDetailModel {
  const ProductDetailModel({
    required this.product,
    required this.dosage,
    required this.packLabel,
    required this.aboutText,
    required this.howToUse,
    required this.safetyInformation,
    this.trustBadges = const [],
    this.keyBenefits = const [],
  });

  final ProductModel product;
  final String dosage;
  final String packLabel;
  final String aboutText;
  final String howToUse;
  final String safetyInformation;
  final List<ProductTrustBadgeModel> trustBadges;
  final List<ProductBenefitModel> keyBenefits;

  String get specificationLabel {
    if (dosage.isEmpty && packLabel.isEmpty) return '';
    if (dosage.isEmpty) return packLabel;
    if (packLabel.isEmpty) return dosage;
    return '$dosage • $packLabel';
  }

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) =>
      ProductDetailModel(
        product: ProductModel.fromJson(convertToMap(json['product'])),
        dosage: convertToString(json['dosage']),
        packLabel: convertToString(json['pack_label']),
        aboutText: convertToString(json['about_text']),
        howToUse: convertToString(json['how_to_use']),
        safetyInformation: convertToString(json['safety_information']),
        trustBadges: convertToList(json['trust_badges'])
            .map((e) => ProductTrustBadgeModel.fromJson(convertToMap(e)))
            .toList(),
        keyBenefits: convertToList(json['key_benefits'])
            .map((e) => ProductBenefitModel.fromJson(convertToMap(e)))
            .toList(),
      );
}

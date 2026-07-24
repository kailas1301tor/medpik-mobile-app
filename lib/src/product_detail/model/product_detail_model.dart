// lib/src/product_detail/model/product_detail_model.dart
import 'package:medpik/data/models/product_model.dart';
import 'package:medpik/src/product_detail/model/product_benefit_model.dart';
import 'package:medpik/src/product_detail/model/product_trust_badge_model.dart';
import 'package:medpik/utils/helpers/product_pack_label_helper.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';

class ProductDetailResponse {
  const ProductDetailResponse({
    required this.results,
    this.message = '',
    this.status = true,
  });

  final ProductDetailResultsModel results;
  final String message;
  final bool status;

  ProductDetailModel? get detail => results.data?.detail;

  ProductModel? get product => detail?.product;

  factory ProductDetailResponse.fromJson(Map<String, dynamic> json) {
    final hasStatus = json.containsKey('status');
    return ProductDetailResponse(
      message: convertToString(json['message']),
      status: hasStatus ? convertToBool(json['status']) : true,
      results: ProductDetailResultsModel.fromJson(
        convertToMap(json['results']),
      ),
    );
  }
}

class ProductDetailResultsModel {
  const ProductDetailResultsModel({this.data});

  final ProductDetailDataModel? data;

  factory ProductDetailResultsModel.fromJson(Map<String, dynamic> json) =>
      ProductDetailResultsModel(
        data: json['data'] == null
            ? null
            : ProductDetailDataModel.fromJson(convertToMap(json['data'])),
      );
}

class ProductDetailDataModel {
  const ProductDetailDataModel({required this.detail});

  final ProductDetailModel detail;

  ProductModel get product => detail.product;

  factory ProductDetailDataModel.fromJson(Map<String, dynamic> json) {
    final product = ProductModel.fromJson(json);
    return ProductDetailDataModel(
      detail: ProductDetailModel.fromProductJson(json, product),
    );
  }
}

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

  factory ProductDetailModel.fromApiProduct(ProductModel product) =>
      ProductDetailModel.fromProductJson(const {}, product);

  factory ProductDetailModel.fromProductJson(
    Map<String, dynamic> json,
    ProductModel product,
  ) =>
      ProductDetailModel(
        product: product,
        dosage: convertToString(json['dosage']),
        packLabel: convertToString(json['pack_label']).isNotEmpty
            ? convertToString(json['pack_label'])
            : productPackDisplayLabel(product),
        aboutText: convertToString(json['about_text']).isNotEmpty
            ? convertToString(json['about_text'])
            : product.description.trim(),
        howToUse: convertToString(json['how_to_use']),
        safetyInformation: convertToString(json['safety_information']),
        trustBadges: convertToList(json['trust_badges'])
            .map((e) => ProductTrustBadgeModel.fromJson(convertToMap(e)))
            .toList(),
        keyBenefits: convertToList(json['key_benefits'])
            .map((e) => ProductBenefitModel.fromJson(convertToMap(e)))
            .toList(),
      );

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

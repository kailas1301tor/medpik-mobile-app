// lib/src/product_detail/model/product_detail_model.dart
import 'package:medpik/data/models/product_model.dart';
import 'package:medpik/src/product_detail/model/product_benefit_model.dart';
import 'package:medpik/src/product_detail/model/product_packaging_model.dart';
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
    this.galleryImageUrls = const [],
    this.packagings = const [],
    this.uses = '',
    this.productInformation = '',
    this.indications = '',
    this.contraindications = '',
    this.warnings = '',
    this.precautions = '',
    this.sideEffects = '',
    this.drugInteractions = '',
    this.storage = '',
    this.drugClass = '',
    this.saltName = '',
    this.strength = '',
  });

  final ProductModel product;
  final String dosage;
  final String packLabel;
  final String aboutText;
  final String howToUse;
  final String safetyInformation;
  final List<ProductTrustBadgeModel> trustBadges;
  final List<ProductBenefitModel> keyBenefits;
  final List<String> galleryImageUrls;
  final List<ProductPackagingModel> packagings;
  final String uses;
  final String productInformation;
  final String indications;
  final String contraindications;
  final String warnings;
  final String precautions;
  final String sideEffects;
  final String drugInteractions;
  final String storage;
  final String drugClass;
  final String saltName;
  final String strength;

  String get specificationLabel {
    if (dosage.isEmpty && packLabel.isEmpty) return '';
    if (dosage.isEmpty) return packLabel;
    if (packLabel.isEmpty) return dosage;
    return '$dosage • $packLabel';
  }

  String get composition => product.composition;

  static List<String> _parseGalleryUrls(
    Map<String, dynamic> json,
    ProductModel product,
  ) {
    final fromProductImages = convertToList(json['product_images'])
        .map(convertToString)
        .where((url) => url.isNotEmpty)
        .toList();
    if (fromProductImages.isNotEmpty) return fromProductImages;

    final fromImages = convertToList(json['images'])
        .map(convertToString)
        .where((url) => url.isNotEmpty)
        .toList();
    if (fromImages.isNotEmpty) return fromImages;

    if (product.images.isNotEmpty) return product.images;
    if (product.imageUrl.isNotEmpty) return [product.imageUrl];
    return const [];
  }

  static String _resolveAboutText(
    Map<String, dynamic> json,
    ProductModel product,
  ) {
    final productInformation = convertToString(json['product_information']);
    if (productInformation.isNotEmpty) return productInformation;
    final aboutText = convertToString(json['about_text']);
    if (aboutText.isNotEmpty) return aboutText;
    return product.description.trim();
  }

  static String _resolvePackLabel(
    Map<String, dynamic> json,
    ProductModel product,
    List<ProductPackagingModel> packagings,
  ) {
    if (packagings.isNotEmpty && packagings.first.displayLabel.isNotEmpty) {
      return packagings.first.displayLabel;
    }
    final packLabel = convertToString(json['pack_label']);
    if (packLabel.isNotEmpty) return packLabel;
    return productPackDisplayLabel(product);
  }

  factory ProductDetailModel.fromApiProduct(ProductModel product) =>
      ProductDetailModel.fromProductJson(const {}, product);

  factory ProductDetailModel.fromProductJson(
    Map<String, dynamic> json,
    ProductModel product,
  ) {
    final packagings = convertToList(json['packagings'])
        .map((e) => ProductPackagingModel.fromJson(convertToMap(e)))
        .toList();

    return ProductDetailModel(
      product: product,
      dosage: convertToString(json['dosage']),
      packLabel: _resolvePackLabel(json, product, packagings),
      aboutText: _resolveAboutText(json, product),
      howToUse: convertToString(json['how_to_use']),
      safetyInformation: convertToString(json['safety_information']),
      trustBadges: convertToList(json['trust_badges'])
          .map((e) => ProductTrustBadgeModel.fromJson(convertToMap(e)))
          .toList(),
      keyBenefits: convertToList(json['key_benefits'])
          .map((e) => ProductBenefitModel.fromJson(convertToMap(e)))
          .toList(),
      galleryImageUrls: _parseGalleryUrls(json, product),
      packagings: packagings,
      uses: convertToString(json['uses']),
      productInformation: convertToString(json['product_information']),
      indications: convertToString(json['indications']),
      contraindications: convertToString(json['contraindications']),
      warnings: convertToString(json['warnings']),
      precautions: convertToString(json['precautions']),
      sideEffects: convertToString(json['side_effects']),
      drugInteractions: convertToString(json['drug_interactions']),
      storage: convertToString(json['storage']),
      drugClass: convertToString(json['drug_class']),
      saltName: convertToString(json['salt_name']),
      strength: convertToString(json['strength']),
    );
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
        galleryImageUrls: convertToList(json['gallery_image_urls'])
            .map(convertToString)
            .where((url) => url.isNotEmpty)
            .toList(),
        packagings: convertToList(json['packagings'])
            .map((e) => ProductPackagingModel.fromJson(convertToMap(e)))
            .toList(),
        uses: convertToString(json['uses']),
        productInformation: convertToString(json['product_information']),
        indications: convertToString(json['indications']),
        contraindications: convertToString(json['contraindications']),
        warnings: convertToString(json['warnings']),
        precautions: convertToString(json['precautions']),
        sideEffects: convertToString(json['side_effects']),
        drugInteractions: convertToString(json['drug_interactions']),
        storage: convertToString(json['storage']),
        drugClass: convertToString(json['drug_class']),
        saltName: convertToString(json['salt_name']),
        strength: convertToString(json['strength']),
      );
}

// lib/src/home/model/home_model.dart
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/utils/helpers/safe_converters.dart';

class HomeFeedModel {
  const HomeFeedModel({
    required this.userName,
    required this.deliveryHint,
    required this.categories,
    required this.offers,
    required this.featuredProducts,
  });

  final String userName;
  final String deliveryHint;
  final List<CategoryModel> categories;
  final List<OfferModel> offers;
  final List<ProductModel> featuredProducts;

  factory HomeFeedModel.fromJson(Map<String, dynamic> json) => HomeFeedModel(
        userName: convertToString(json['user_name']),
        deliveryHint: convertToString(json['delivery_hint']),
        categories: convertToList(json['categories'])
            .map((e) => CategoryModel.fromJson(convertToMap(e)))
            .toList(),
        offers: convertToList(json['offers'])
            .map((e) => OfferModel.fromJson(convertToMap(e)))
            .toList(),
        featuredProducts: convertToList(json['featured_products'])
            .map((e) => ProductModel.fromJson(convertToMap(e)))
            .toList(),
      );
}

class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.iconKey,
    this.imageUrl = '',
  });

  final int id;
  final String name;
  final String iconKey;
  final String imageUrl;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: convertToInt(json['id']),
        name: convertToString(json['name']),
        iconKey: convertToString(json['icon_key']),
        imageUrl: convertToString(json['image_url']),
      );
}

class OfferModel {
  const OfferModel({
    required this.id,
    required this.title,
    required this.subtitle,
    this.badgeLabel,
    this.promoCode,
    this.backgroundKey,
  });

  final int id;
  final String title;
  final String subtitle;
  final String? badgeLabel;
  final String? promoCode;
  final String? backgroundKey;

  factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
        id: convertToInt(json['id']),
        title: convertToString(json['title']),
        subtitle: convertToString(json['subtitle']),
        badgeLabel: convertToString(json['badge_label']),
        promoCode: convertToString(json['promo_code']),
        backgroundKey: convertToString(json['background_key']),
      );
}

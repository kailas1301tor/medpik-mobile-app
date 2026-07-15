// lib/src/home/model/home_model.dart
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/utils/helpers/safe_converters.dart';

class HomeFeedModel {
  const HomeFeedModel({
    required this.results,
    this.greeting = '',
    this.deliveryHint = '',
    this.message = '',
    this.status = true,
  });

  final HomeResultsModel results;
  final String greeting;
  final String deliveryHint;
  final String message;
  final bool status;

  List<CategoryModel> get categories => results.data?.categories ?? const [];
  List<OfferModel> get offers => results.data?.offers ?? const [];
  List<ProductModel> get featuredProducts =>
      results.data?.products ?? const [];

  factory HomeFeedModel.fromJson(Map<String, dynamic> json) {
    final hasStatus = json.containsKey('status');
    return HomeFeedModel(
      message: convertToString(json['message']),
      status: hasStatus ? convertToBool(json['status']) : true,
      results: HomeResultsModel.fromJson(convertToMap(json['results'])),
    );
  }

  HomeFeedModel copyWith({
    HomeResultsModel? results,
    String? greeting,
    String? deliveryHint,
    String? message,
    bool? status,
  }) =>
      HomeFeedModel(
        results: results ?? this.results,
        greeting: greeting ?? this.greeting,
        deliveryHint: deliveryHint ?? this.deliveryHint,
        message: message ?? this.message,
        status: status ?? this.status,
      );
}

class HomeResultsModel {
  const HomeResultsModel({this.data});

  final HomeDataModel? data;

  factory HomeResultsModel.fromJson(Map<String, dynamic> json) =>
      HomeResultsModel(
        data: json['data'] == null
            ? null
            : HomeDataModel.fromJson(convertToMap(json['data'])),
      );
}

class HomeDataModel {
  const HomeDataModel({
    this.categories = const [],
    this.offers = const [],
    this.products = const [],
  });

  final List<CategoryModel> categories;
  final List<OfferModel> offers;
  final List<ProductModel> products;

  factory HomeDataModel.fromJson(Map<String, dynamic> json) => HomeDataModel(
        categories: convertToList(json['categories'])
            .map((e) => CategoryModel.fromJson(convertToMap(e)))
            .toList(),
        offers: convertToList(json['offers'])
            .map((e) => OfferModel.fromJson(convertToMap(e)))
            .toList(),
        products: convertToList(json['products'])
            .map((e) => ProductModel.fromJson(convertToMap(e)))
            .toList(),
      );
}

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

class OfferModel {
  const OfferModel({
    required this.id,
    required this.title,
    required this.subtitle,
    this.badgeLabel,
    this.promoCode,
    this.gradientColor1,
    this.gradientColor2,
    this.discountValue,
    this.discountType,
  });

  final int id;
  final String title;
  final String subtitle;
  final String? badgeLabel;
  final String? promoCode;
  final String? gradientColor1;
  final String? gradientColor2;
  final double? discountValue;
  final String? discountType;

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    final subtitle = convertToString(json['description']).isNotEmpty
        ? convertToString(json['description'])
        : convertToString(json['subtitle']);
    final badgeLabel = convertToString(json['offer_label']).isNotEmpty
        ? convertToString(json['offer_label'])
        : convertToString(json['badge_label']);
    final promoCode = convertToString(json['coupon_code']).isNotEmpty
        ? convertToString(json['coupon_code'])
        : convertToString(json['promo_code']);

    return OfferModel(
      id: convertToInt(json['id']),
      title: convertToString(json['title']),
      subtitle: subtitle,
      badgeLabel: badgeLabel.isEmpty ? null : badgeLabel,
      promoCode: promoCode.isEmpty ? null : promoCode,
      gradientColor1: convertToString(json['gradient_color_1']).isEmpty
          ? null
          : convertToString(json['gradient_color_1']),
      gradientColor2: convertToString(json['gradient_color_2']).isEmpty
          ? null
          : convertToString(json['gradient_color_2']),
      discountValue: json['discount_value'] == null
          ? null
          : convertToDouble(json['discount_value']),
      discountType: convertToString(json['discount_type']).isEmpty
          ? null
          : convertToString(json['discount_type']),
    );
  }
}

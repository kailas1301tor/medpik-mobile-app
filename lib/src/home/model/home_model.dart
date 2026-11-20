// lib/src/home/model/home_model.dart
import 'package:medpik/data/models/category_model.dart';
import 'package:medpik/data/models/product_model.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';

export 'package:medpik/data/models/category_model.dart';

class HomeFeedModel {
  const HomeFeedModel({
    required this.results,
    this.greeting = '',
    this.userName = '',
    this.deliveryHint = '',
    this.message = '',
    this.status = true,
  });

  final HomeResultsModel results;
  final String greeting;
  final String userName;
  final String deliveryHint;
  final String message;
  final bool status;

  List<CategoryModel> get categories => results.data?.categories ?? const [];
  List<OfferModel> get offers => results.data?.offers ?? const [];
  List<ProductModel> get featuredProducts =>
      results.data?.products ?? const [];
  List<HomeBannerModel> get banners => results.data?.banners ?? const [];
  List<ProductModel> get vitaminsAndSupplements =>
      results.data?.vitaminsAndSupplements ?? const [];
  List<ProductModel> get personalCare =>
      results.data?.personalCare ?? const [];
  List<ProductModel> get babyCare => results.data?.babyCare ?? const [];
  String get supportPhone => results.data?.supportPhone ?? '';
  int get inAppNotificationCount =>
      results.data?.inAppNotificationCount ?? 0;

  List<String> get bannerImageUrls => banners
      .map((b) => b.imageUrl.trim())
      .where((url) => url.isNotEmpty)
      .toList(growable: false);

  factory HomeFeedModel.fromJson(Map<String, dynamic> json) {
    final hasStatus = json.containsKey('status');
    final resultsMap = convertToMap(json['results']);
    final results = HomeResultsModel.fromJson(resultsMap);

    // Prefer data.support_phone; fall back to results/root if API nests it higher.
    final nestedPhone = results.data?.supportPhone.trim() ?? '';
    final resultsPhone = convertToString(resultsMap['support_phone']).trim();
    final rootPhone = convertToString(json['support_phone']).trim();
    final fallbackPhone =
        resultsPhone.isNotEmpty ? resultsPhone : rootPhone;

    final resolvedResults = nestedPhone.isNotEmpty || fallbackPhone.isEmpty
        ? results
        : HomeResultsModel(
            data: (results.data ?? const HomeDataModel()).copyWith(
              supportPhone: fallbackPhone,
            ),
          );

    return HomeFeedModel(
      message: convertToString(json['message']),
      status: hasStatus ? convertToBool(json['status']) : true,
      results: resolvedResults,
    );
  }

  HomeFeedModel copyWith({
    HomeResultsModel? results,
    String? greeting,
    String? userName,
    String? deliveryHint,
    String? message,
    bool? status,
  }) =>
      HomeFeedModel(
        results: results ?? this.results,
        greeting: greeting ?? this.greeting,
        userName: userName ?? this.userName,
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
    this.banners = const [],
    this.categories = const [],
    this.offers = const [],
    this.products = const [],
    this.vitaminsAndSupplements = const [],
    this.personalCare = const [],
    this.babyCare = const [],
    this.supportPhone = '',
    this.inAppNotificationCount = 0,
  });

  final List<HomeBannerModel> banners;
  final List<CategoryModel> categories;
  final List<OfferModel> offers;
  final List<ProductModel> products;
  final List<ProductModel> vitaminsAndSupplements;
  final List<ProductModel> personalCare;
  final List<ProductModel> babyCare;
  final String supportPhone;
  final int inAppNotificationCount;

  HomeDataModel copyWith({
    List<HomeBannerModel>? banners,
    List<CategoryModel>? categories,
    List<OfferModel>? offers,
    List<ProductModel>? products,
    List<ProductModel>? vitaminsAndSupplements,
    List<ProductModel>? personalCare,
    List<ProductModel>? babyCare,
    String? supportPhone,
    int? inAppNotificationCount,
  }) =>
      HomeDataModel(
        banners: banners ?? this.banners,
        categories: categories ?? this.categories,
        offers: offers ?? this.offers,
        products: products ?? this.products,
        vitaminsAndSupplements:
            vitaminsAndSupplements ?? this.vitaminsAndSupplements,
        personalCare: personalCare ?? this.personalCare,
        babyCare: babyCare ?? this.babyCare,
        supportPhone: supportPhone ?? this.supportPhone,
        inAppNotificationCount:
            inAppNotificationCount ?? this.inAppNotificationCount,
      );

  static List<ProductModel> _parseProducts(dynamic raw) => convertToList(raw)
      .map((e) => ProductModel.fromJson(convertToMap(e)))
      .toList();

  factory HomeDataModel.fromJson(Map<String, dynamic> json) => HomeDataModel(
        banners: convertToList(json['banners'])
            .map((e) => HomeBannerModel.fromJson(convertToMap(e)))
            .toList(),
        categories: convertToList(json['categories'])
            .map((e) => CategoryModel.fromJson(convertToMap(e)))
            .toList(),
        offers: convertToList(json['offers'])
            .map((e) => OfferModel.fromJson(convertToMap(e)))
            .toList(),
        products: _parseProducts(json['products']),
        vitaminsAndSupplements: _parseProducts(json['vitamins_and_supplements']),
        personalCare: _parseProducts(json['personal_care']),
        babyCare: _parseProducts(json['baby_care']),
        supportPhone: convertToString(json['support_phone']),
        inAppNotificationCount: convertToInt(json['in_app_notification_count']),
      );
}

class HomeBannerModel {
  const HomeBannerModel({
    required this.id,
    this.title = '',
    this.imageUrl = '',
  });

  final int id;
  final String title;
  final String imageUrl;

  factory HomeBannerModel.fromJson(Map<String, dynamic> json) =>
      HomeBannerModel(
        id: convertToInt(json['id']),
        title: convertToString(json['title']),
        imageUrl: convertToString(json['image']),
      );
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
    this.imageUrl = '',
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
  final String imageUrl;

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
      imageUrl: convertToString(json['image']),
    );
  }
}

// lib/res/constants/medpik_image_assets.dart
class MedpikImageAssets {
  MedpikImageAssets._();

  static const String _base = 'assets/images/png';
  static const String _gifBase = 'assets/images/gif';

  /// Horizontal wordmark — native and in-app splash.
  static const String splashLogo = '$_base/medpik_splash_logo.png';

  /// Vertical lockup — centered branding.
  static const String appLogo = '$_base/Medpik Logo #02.png';

  /// Horizontal lockup — wide headers (login, etc.).
  static const String appLogoHorizontal = '$_base/Medpik Logo #01.png';

  /// Icon mark only — launcher, compact UI.
  static const String appCrest = '$_base/Medpik Crest #01.png';
  static const String primaryBackground = '$_gifBase/home_header_bg.gif';
  static const String productPlaceholder =
      '$_base/order_product_placeholder.jpg';
  static const String categoryPlaceholder =
      '$_base/category_placeholder_green.png';
  static const String homePrescriptionUploadArt =
      '$_gifBase/home_prescription_upload_art.gif';
  static const String orderProductPlaceholder =
      '$_base/order_product_placeholder.jpg';

  /// Hardcoded "Offers for you" banners (until home API returns image URLs).
  static const String homeOfferBanner01 = '$_base/home_offer_banner_01.png';
  static const String homeOfferBanner02 = '$_base/home_offer_banner_02.png';
  static const String homeOfferBanner03 = '$_base/home_offer_banner_03.png';

  /// Hardcoded featured-brand banners (below popular products).
  static const String homePromoBanner01 = '$_base/home_promo_banner_01.png';
  static const String homePromoBanner02 = '$_base/home_promo_banner_02.png';
}

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
      '$_base/product_placeholder_green.png';
  static const String categoryPlaceholder =
      '$_base/category_placeholder_green.png';
}

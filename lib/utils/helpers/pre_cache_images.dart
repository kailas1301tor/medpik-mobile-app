// lib/utils/helpers/pre_cache_images.dart
import 'package:flutter/material.dart';
import 'package:medpik/res/constants/medpik_image_assets.dart';

/// Holds in-memory [Image] widgets for critical PNG/JPG assets and warms the
/// Flutter image cache during splash so the first home/login paint is instant.
class PreCacheImages {
  PreCacheImages._();

  static bool _initialized = false;

  static late Image primaryBackground;
  static late Image productPlaceholder;
  static late Image categoryPlaceholder;
  static late Image appLogoVertical;
  static late Image appLogoHorizontal;
  static late Image splashLogo;
  static late Image appCrest;

  static void initializeAllImages() {
    if (_initialized) return;

    primaryBackground = Image.asset(
      MedpikImageAssets.primaryBackground,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      gaplessPlayback: true,
    );
    productPlaceholder = Image.asset(
      MedpikImageAssets.productPlaceholder,
      fit: BoxFit.cover,
      gaplessPlayback: true,
    );
    categoryPlaceholder = Image.asset(
      MedpikImageAssets.categoryPlaceholder,
      fit: BoxFit.cover,
      gaplessPlayback: true,
    );
    appLogoVertical = Image.asset(
      MedpikImageAssets.appLogo,
      fit: BoxFit.contain,
      gaplessPlayback: true,
    );
    appLogoHorizontal = Image.asset(
      MedpikImageAssets.appLogoHorizontal,
      fit: BoxFit.contain,
      gaplessPlayback: true,
    );
    splashLogo = Image.asset(
      MedpikImageAssets.splashLogo,
      fit: BoxFit.contain,
      gaplessPlayback: true,
    );
    appCrest = Image.asset(
      MedpikImageAssets.appCrest,
      fit: BoxFit.contain,
      gaplessPlayback: true,
    );

    _initialized = true;
  }

  static Future<void> preCacheImages(BuildContext context) async {
    if (!_initialized) {
      initializeAllImages();
    }

    await Future.wait([
      precacheImage(primaryBackground.image, context),
      precacheImage(productPlaceholder.image, context),
      precacheImage(categoryPlaceholder.image, context),
      precacheImage(appLogoVertical.image, context),
      precacheImage(appLogoHorizontal.image, context),
      precacheImage(splashLogo.image, context),
      precacheImage(appCrest.image, context),
    ]);
  }

  static ImageProvider? providerFor(String assetPath) {
    if (!_initialized) return null;

    return switch (assetPath) {
      MedpikImageAssets.primaryBackground => primaryBackground.image,
      MedpikImageAssets.productPlaceholder => productPlaceholder.image,
      MedpikImageAssets.categoryPlaceholder => categoryPlaceholder.image,
      MedpikImageAssets.appLogo => appLogoVertical.image,
      MedpikImageAssets.appLogoHorizontal => appLogoHorizontal.image,
      MedpikImageAssets.splashLogo => splashLogo.image,
      MedpikImageAssets.appCrest => appCrest.image,
      _ => null,
    };
  }
}

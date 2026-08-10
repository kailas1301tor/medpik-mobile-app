// lib/utils/common_widgets/medpik_logo.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/medpik_image_assets.dart';
import 'package:medpik/res/styles/color_palette.dart';

enum MedpikLogoVariant { crest, horizontal, vertical }

/// How the black PNG plate is presented against the parent surface.
enum MedpikLogoPlateStyle {
  /// Black rounded plate on light surfaces; direct asset on dark/primary surfaces.
  auto,

  /// Always wrap in a black rounded plate.
  plate,

  /// Show the asset directly (no extra plate).
  none,
}

/// Theme-aware Medpik brand logo using provided PNG lockups.
class MedpikLogo extends StatelessWidget {
  const MedpikLogo({
    super.key,
    required this.variant,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    this.plateStyle = MedpikLogoPlateStyle.auto,
    this.surfaceIsDark = false,
  });

  final MedpikLogoVariant variant;
  final double? height;
  final double? width;
  final BoxFit fit;
  final MedpikLogoPlateStyle plateStyle;

  /// When true, treats the parent surface as dark/primary (skips plate in auto mode).
  final bool surfaceIsDark;

  String _assetPath() {
    return switch (variant) {
      MedpikLogoVariant.crest => MedpikImageAssets.appCrest,
      MedpikLogoVariant.horizontal => MedpikImageAssets.appLogoHorizontal,
      MedpikLogoVariant.vertical => MedpikImageAssets.appLogo,
    };
  }

  bool _shouldUsePlate(BuildContext context) {
    switch (plateStyle) {
      case MedpikLogoPlateStyle.plate:
        return true;
      case MedpikLogoPlateStyle.none:
        return false;
      case MedpikLogoPlateStyle.auto:
        if (surfaceIsDark) return false;
        final brightness = Theme.of(context).brightness;
        final colors = context.appColors;
        final surfaceBrightness = ThemeData.estimateBrightnessForColor(
          colors.background,
        );
        return brightness == Brightness.light &&
            surfaceBrightness == Brightness.light;
    }
  }

  @override
  Widget build(BuildContext context) {
    final assetPath = _assetPath();
    final image = Image.asset(
      assetPath,
      height: height,
      width: width,
      fit: fit,
      gaplessPlayback: true,
    );

    if (!_shouldUsePlate(context)) {
      return image;
    }

    final padding = switch (variant) {
      MedpikLogoVariant.crest => EdgeInsets.all(8.r),
      MedpikLogoVariant.horizontal => EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 8.h,
      ),
      MedpikLogoVariant.vertical => EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 12.h,
      ),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: ColorPalette.black,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(padding: padding, child: image),
    );
  }
}

// lib/src/home/view/widget/home_prescription_card.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/src/home/view/widget/home_prescription_card_surface.dart';

class HomePrescriptionCard extends StatelessWidget {
  const HomePrescriptionCard({super.key, this.onUploadTap});

  final VoidCallback? onUploadTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final radius = BorderRadius.circular(20.r);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glassSurface = isDark
        ? colors.cardBackground.withValues(alpha: 0.92)
        : ColorPalette.glassSurface;
    final glassBorder = isDark
        ? colors.primary.withValues(alpha: 0.22)
        : ColorPalette.prescriptionGlassBorder;
    final cardShadow = isDark
        ? [
            ...ColorPalette.glassCardShadow,
            ...ColorPalette.prescriptionCardShadow,
            ...ColorPalette.productGlassCardShadow(depth: 0.85),
          ]
        : [
            ...ColorPalette.productCardShadow,
            ...ColorPalette.prescriptionCardShadow,
            BoxShadow(
              color: ColorPalette.black.withValues(alpha: 0.07),
              blurRadius: 28.r,
              offset: Offset(0, 12.h),
            ),
          ];

    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: radius, boxShadow: cardShadow),
      child: SmoothClipRRect(
        smoothness: 2,
        borderRadius: radius,
        child: isDark
            ? BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
                child: HomePrescriptionCardSurface(
                  radius: radius,
                  isDark: isDark,
                  glassSurface: glassSurface,
                  glassBorder: glassBorder,
                  onUploadTap: onUploadTap,
                ),
              )
            : HomePrescriptionCardSurface(
                radius: radius,
                isDark: isDark,
                glassSurface: glassSurface,
                glassBorder: glassBorder,
                onUploadTap: onUploadTap,
              ),
      ),
    );
  }
}

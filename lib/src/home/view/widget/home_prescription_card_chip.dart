// lib/src/home/view/widget/home_prescription_card_chip.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tsuite/res/constants/medpik_svg_assets.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';

class HomePrescriptionCardRadialGlow extends StatelessWidget {
  const HomePrescriptionCardRadialGlow({
    super.key,
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withValues(alpha: 0.0)],
          ),
        ),
      ),
    );
  }
}

class HomePrescriptionCardGlassChip extends StatelessWidget {
  const HomePrescriptionCardGlassChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final chipFill = isDark
        ? colors.inputBackground
        : ColorPalette.glassChipFill;
    final chipBorder = isDark
        ? colors.cardBorder
        : ColorPalette.white.withValues(alpha: 0.55);

    return ClipRRect(
      borderRadius: BorderRadius.circular(100.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: chipFill,
            borderRadius: BorderRadius.circular(100.r),
            border: Border.all(color: chipBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                MedpikSvgAssets.check,
                width: 11.r,
                height: 11.r,
              ),
              3.horizontalSpace,
              Text(
                label,
                style: FontPalette.base500(10, color: colors.primaryText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

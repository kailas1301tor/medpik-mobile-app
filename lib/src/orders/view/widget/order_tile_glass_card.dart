// lib/src/orders/view/widget/order_tile_glass_card.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';

class OrderTileGlassCard extends StatelessWidget {
  const OrderTileGlassCard({
    super.key,
    required this.child,
    this.onTap,
  });

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = BorderRadius.circular(16.r);
    final surface = isDark
        ? colors.cardBackground.withValues(alpha: 0.9)
        : ColorPalette.glassSurface;
    final borderColor = isDark
        ? colors.cardBorder.withValues(alpha: 0.45)
        : ColorPalette.prescriptionGlassBorder;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: ColorPalette.productCardShadow,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Material(
            color: surface,
            child: InkWell(
              onTap: onTap,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor, width: 1.w),
                  borderRadius: radius,
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.r),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// lib/src/product_detail/view/widget/product_detail_floating_action.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/utils/extensions/context_extensions.dart';

class ProductDetailFloatingAction extends StatelessWidget {
  const ProductDetailFloatingAction({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = context.isDarkMode;
    final size = 40.r;

    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: ColorPalette.black.withValues(
              alpha: isDark ? 0.35 : 0.1,
            ),
            blurRadius: 12,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Material(
        color: isDark
            ? colors.surface.withValues(alpha: 0.92)
            : ColorPalette.white,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(
              icon,
              size: 20.r,
              color: iconColor ?? colors.primaryText,
            ),
          ),
        ),
      ),
    );
  }
}

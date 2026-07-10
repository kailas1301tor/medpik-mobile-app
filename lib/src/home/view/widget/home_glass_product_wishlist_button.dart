// lib/src/home/view/widget/home_glass_product_wishlist_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/styles/color_palette.dart';

class HomeGlassProductWishlistButton extends StatelessWidget {
  const HomeGlassProductWishlistButton({
    super.key,
    required this.isWishlisted,
    required this.onTap,
  });

  final bool isWishlisted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 30.r,
        height: 30.r,
        decoration: BoxDecoration(
          color: ColorPalette.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: ColorPalette.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            isWishlisted
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            size: 16.r,
            color: isWishlisted
                ? ColorPalette.prescriptionUploadBtn
                : ColorPalette.productAccentTeal,
          ),
        ),
      ),
    );
  }
}

// lib/src/home/view/widget/home_glass_product_wishlist_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/utils/common_widgets/common_wishlist_button.dart';

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
    return CommonWishlistButton(
      isWishlisted: isWishlisted,
      onTap: onTap,
      size: 30.r,
      iconSize: 16.r,
    );
  }
}

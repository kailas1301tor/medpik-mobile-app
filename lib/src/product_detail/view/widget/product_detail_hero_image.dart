// lib/src/product_detail/view/widget/product_detail_hero_image.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/utils/common_widgets/common_cached_network_image.dart';
import 'package:tsuite/utils/extensions/context_extensions.dart';

class ProductDetailHeroImage extends StatelessWidget {
  const ProductDetailHeroImage({
    super.key,
    required this.imageUrl,
    this.activePage = 0,
    this.pageCount = 4,
  });

  final String imageUrl;
  final int activePage;
  final int pageCount;

  static double heightFor(BuildContext context) =>
      context.screenHeight * 0.42;

  @override
  Widget build(BuildContext context) {
    final heroHeight = heightFor(context);

    return SizedBox(
      height: heroHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CommonCachedNetworkImage(
            imageUrl: imageUrl,
            width: double.infinity,
            height: heroHeight,
            borderRadius: 0,
            fit: BoxFit.cover,
            memCacheWidth: 800,
            memCacheHeight: 800,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ColorPalette.black.withValues(alpha: 0.08),
                  ColorPalette.black.withValues(alpha: 0.02),
                  ColorPalette.black.withValues(alpha: 0.18),
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 36.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pageCount, (index) {
                final isActive = index == activePage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  width: isActive ? 8.r : 6.r,
                  height: isActive ? 8.r : 6.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? ColorPalette.white
                        : ColorPalette.white.withValues(alpha: 0.45),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

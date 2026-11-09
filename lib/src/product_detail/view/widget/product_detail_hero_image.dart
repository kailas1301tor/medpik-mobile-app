// lib/src/product_detail/view/widget/product_detail_hero_image.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/utils/common_widgets/common_cached_network_image.dart';
import 'package:medpik/utils/extensions/context_extensions.dart';

class ProductDetailHeroImage extends StatelessWidget {
  const ProductDetailHeroImage({
    super.key,
    required this.imageUrls,
    required this.pageController,
    required this.activeIndex,
    required this.onPageChanged,
  });

  final List<String> imageUrls;
  final PageController pageController;
  final int activeIndex;
  final ValueChanged<int> onPageChanged;

  static double heightFor(BuildContext context) =>
      context.screenHeight * 0.42;

  @override
  Widget build(BuildContext context) {
    final heroHeight = heightFor(context);
    final urls = imageUrls.isEmpty ? const [''] : imageUrls;
    final showDots = urls.length > 1;

    return SizedBox(
      height: heroHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: urls.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  CommonCachedNetworkImage(
                    imageUrl: urls[index],
                    width: double.infinity,
                    height: heroHeight,
                    borderRadius: 0,
                    fit: BoxFit.cover,
                    memCacheMax: 800,
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
                ],
              );
            },
          ),
          if (showDots)
            Positioned(
              left: 0,
              right: 0,
              bottom: 40.h,
              child: _GalleryDots(
                count: urls.length,
                activeIndex: activeIndex.clamp(0, urls.length - 1),
              ),
            ),
        ],
      ),
    );
  }
}

class _GalleryDots extends StatelessWidget {
  const _GalleryDots({
    required this.count,
    required this.activeIndex,
  });

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          width: isActive ? 18.w : 6.w,
          height: 6.h,
          decoration: BoxDecoration(
            color: isActive
                ? ColorPalette.white
                : ColorPalette.white.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(999.r),
          ),
        );
      }),
    );
  }
}

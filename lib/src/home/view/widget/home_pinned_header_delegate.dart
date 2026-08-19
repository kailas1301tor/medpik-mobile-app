// lib/src/home/view/widget/home_pinned_header_delegate.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/src/home/view/widget/home_header_section.dart';
import 'package:medpik/utils/helpers/pre_cache_images.dart';

class HomePinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  HomePinnedHeaderDelegate({
    required this.topInset,
    required this.greeting,
    required this.deliveryHint,
    required this.onSearchTap,
  });

  final double topInset;
  final String greeting;
  final String deliveryHint;
  final VoidCallback onSearchTap;

  double get _contentHeight => 210.h;

  @override
  double get minExtent => topInset + _contentHeight;

  @override
  double get maxExtent => topInset + _contentHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        shape: SmoothRectangleBorder(
          smoothness: 3,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24.r),
            bottomRight: Radius.circular(24.r),
          ),
        ),
        color: ColorPalette.homePinnedHeaderBackground,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image(
            image: PreCacheImages.primaryBackground.image,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            gaplessPlayback: true,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ColorPalette.black.withValues(alpha: 0.06),
                  ColorPalette.black.withValues(alpha: 0.28),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: topInset),
            child: HomeHeaderSection(
              greeting: greeting,
              deliveryHint: deliveryHint,
              onSearchTap: onSearchTap,
              isOnDarkBackground: true,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 12.h,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ColorPalette.homePinnedHeaderFadeTop,
                    ColorPalette.homePinnedHeaderFadeBottom,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant HomePinnedHeaderDelegate oldDelegate) {
    return greeting != oldDelegate.greeting ||
        deliveryHint != oldDelegate.deliveryHint ||
        topInset != oldDelegate.topInset;
  }
}

// lib/src/home/view/widget/home_pinned_header_delegate.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:tsuite/res/constants/medpik_image_assets.dart';
import 'package:tsuite/src/home/view/widget/home_header_section.dart';

class HomePinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  HomePinnedHeaderDelegate({
    required this.topInset,
    required this.greeting,
    required this.deliveryHint,
    required this.searchController,
    required this.onSearchTap,
  });

  final double topInset;
  final String greeting;
  final String deliveryHint;
  final TextEditingController searchController;
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
        color: const Color(0xFF043745),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            MedpikImageAssets.primaryBackground,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.06),
                  Colors.black.withValues(alpha: 0.28),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: topInset),
            child: HomeHeaderSection(
              greeting: greeting,
              deliveryHint: deliveryHint,
              searchController: searchController,
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
                  colors: [Color(0x00000000), Color(0x14000000)],
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
        searchController != oldDelegate.searchController ||
        topInset != oldDelegate.topInset;
  }
}

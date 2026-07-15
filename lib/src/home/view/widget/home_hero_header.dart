// lib/src/home/view/widget/home_hero_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/medpik_image_assets.dart';
import 'package:tsuite/res/constants/medpik_svg_assets.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/home/view/widget/home_header_shared.dart';
import 'package:tsuite/utils/routes/route_constants.dart';

class HomeHeroHeader extends StatelessWidget {
  const HomeHeroHeader({
    super.key,
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

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.only(
      bottomLeft: Radius.circular(24.r),
      bottomRight: Radius.circular(24.r),
    );

    return SizedBox(
      height: topInset + 210.h,
      child: ClipRRect(
        borderRadius: radius,
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
                    ColorPalette.black.withValues(alpha: 0.06),
                    ColorPalette.black.withValues(alpha: 0.28),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: topInset),
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 22.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            greeting,
                            style: FontPalette.base700(
                              22,
                              color: ColorPalette.white,
                            ),
                          ),
                        ),
                        HomeHeaderIconButton(
                          iconAsset: MedpikSvgAssets.heart,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RouteConstants.routeWishlistScreen,
                            );
                          },
                        ),
                        8.horizontalSpace,
                        HomeHeaderIconButton(
                          iconAsset: MedpikSvgAssets.notification,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RouteConstants.routeNotificationsScreen,
                            );
                          },
                        ),
                      ],
                    ),
                    8.verticalSpace,
                    HomeHeaderLocationRow(
                      deliveryHint: deliveryHint,
                      isOnDarkBackground: true,
                    ),
                    20.verticalSpace,
                    HomeHeaderSearchRow(
                      searchController: searchController,
                      onSearchTap: onSearchTap,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 12.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ColorPalette.black.withValues(alpha: 0.0),
                      ColorPalette.black.withValues(alpha: 0.08),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

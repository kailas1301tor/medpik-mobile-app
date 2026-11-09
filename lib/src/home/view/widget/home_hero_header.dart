// lib/src/home/view/widget/home_hero_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/medpik_svg_assets.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/home/view/widget/home_header_background_gif.dart';
import 'package:medpik/src/home/view/widget/home_header_shared.dart';
import 'package:medpik/utils/common_widgets/common_shimmer_box.dart';
import 'package:medpik/utils/routes/route_constants.dart';

class HomeHeroHeader extends StatelessWidget {
  const HomeHeroHeader({
    super.key,
    required this.topInset,
    required this.greeting,
    required this.userName,
    required this.deliveryHint,
    required this.onSearchTap,
    this.animateBackground = true,
    this.isLoading = false,
  });

  final double topInset;
  final String greeting;
  final String userName;
  final String deliveryHint;
  final VoidCallback onSearchTap;
  final bool animateBackground;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.only(
      bottomLeft: Radius.circular(28.r),
      bottomRight: Radius.circular(28.r),
    );
    return SizedBox(
      height: topInset + 356.h,
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Brief fallback while GifView decodes (usually instant after splash prefetch).
            const ColoredBox(color: ColorPalette.primaryColor),
            HomeHeaderBackgroundGif(animate: animateBackground),
            Padding(
              padding: EdgeInsets.only(top: topInset),
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _HomeHeroGreetingBlock(
                            greeting: greeting,
                            userName: userName,
                            deliveryHint: deliveryHint,
                            isLoading: isLoading,
                          ),
                        ),
                        HomeHeaderIconButton(
                          iconAsset: MedpikSvgAssets.heart,
                          iconColor: ColorPalette.homeHeaderActionIcon,
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
                          iconColor: ColorPalette.homeHeaderActionIcon,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RouteConstants.routeNotificationsScreen,
                            );
                          },
                        ),
                      ],
                    ),
                    const Spacer(),
                    HomeHeaderSearchRow(onSearchTap: onSearchTap),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeroGreetingBlock extends StatelessWidget {
  const _HomeHeroGreetingBlock({
    required this.greeting,
    required this.userName,
    required this.deliveryHint,
    required this.isLoading,
  });

  final String greeting;
  final String userName;
  final String deliveryHint;
  final bool isLoading;

  static final Color _shimmerBase = ColorPalette.white.withValues(alpha: 0.28);
  static final Color _shimmerHighlight = ColorPalette.white.withValues(
    alpha: 0.55,
  );

  @override
  Widget build(BuildContext context) {
    final name = userName.trim();

    return GestureDetector(
      onTap: isLoading
          ? null
          : () {
              Navigator.pushNamed(
                context,
                RouteConstants.routeAddressBookScreen,
              );
            },
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting.isNotEmpty ? greeting : Strings.goodMorningGreeting,
            style: FontPalette.base500(16, color: ColorPalette.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          2.verticalSpace,
          if (name.isNotEmpty)
            Text(
              name,
              style: FontPalette.fWhite_32_700,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          else if (isLoading)
            CommonShimmerBox(
              height: 30.h,
              width: 148.w,
              borderRadius: 8.r,
              color: _shimmerBase,
              baseColor: _shimmerBase,
              highlightColor: _shimmerHighlight,
            ),
          10.verticalSpace,
          Text(
            Strings.deliveringTo,
            style: FontPalette.base700(12, color: ColorPalette.white),
          ),
          2.verticalSpace,
          if (deliveryHint.isNotEmpty)
            Text(
              deliveryHint,
              style: FontPalette.base400(
                12,
                color: ColorPalette.white.withValues(alpha: 0.92),
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            )
          else if (isLoading)
            CommonShimmerBox(
              height: 12.h,
              width: 200.w,
              borderRadius: 6.r,
              color: _shimmerBase,
              baseColor: _shimmerBase,
              highlightColor: _shimmerHighlight,
            )
          else
            Text(
              Strings.selectDeliveryAddress,
              style: FontPalette.base400(
                12,
                color: ColorPalette.white.withValues(alpha: 0.92),
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}

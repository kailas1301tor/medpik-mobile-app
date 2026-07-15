// lib/src/home/view/widget/home_header_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tsuite/res/constants/medpik_svg_assets.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/home/view/widget/home_header_shared.dart';
import 'package:tsuite/utils/common_widgets/common_search_bar.dart';
import 'package:tsuite/utils/routes/route_constants.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({
    super.key,
    required this.userName,
    required this.deliveryHint,
    required this.searchController,
    required this.onSearchTap,
    this.isOnDarkBackground = false,
  });

  final String userName;
  final String deliveryHint;
  final TextEditingController searchController;
  final VoidCallback onSearchTap;
  final bool isOnDarkBackground;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final titleColor = isOnDarkBackground
        ? ColorPalette.white
        : colors.primaryText;
    final secondaryColor = isOnDarkBackground
        ? ColorPalette.white.withValues(alpha: 0.8)
        : colors.secondaryText;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 22.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${Strings.homeGreeting}, $userName',
                  style: FontPalette.base700(22, color: titleColor),
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
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                RouteConstants.routeAddressBookScreen,
              );
            },
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  MedpikSvgAssets.location,
                  width: 30.w,
                  height: 30.w,
                ),
                4.horizontalSpace,
                Expanded(
                  child: Text(
                    deliveryHint,
                    style: FontPalette.base700(13, color: secondaryColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                6.horizontalSpace,
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20.r,
                  color: secondaryColor,
                ),
              ],
            ),
          ),
          14.verticalSpace,
          GestureDetector(
            onTap: onSearchTap,
            behavior: HitTestBehavior.opaque,
            child: IgnorePointer(
              child: CommonSearchBar(
                controller: searchController,
                hintText: Strings.searchMedicinesHealthcare,
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                  child: SvgPicture.asset(
                    MedpikSvgAssets.search,
                    width: 24.w,
                    height: 24.w,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

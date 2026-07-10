// lib/src/home/view/widget/home_header_shared.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tsuite/res/constants/medpik_svg_assets.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/utils/common_widgets/common_search_bar.dart';
import 'package:tsuite/utils/routes/route_constants.dart';

class HomeHeaderLocationRow extends StatelessWidget {
  const HomeHeaderLocationRow({
    super.key,
    required this.deliveryHint,
    this.isOnDarkBackground = false,
  });

  final String deliveryHint;
  final bool isOnDarkBackground;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textColor = isOnDarkBackground
        ? ColorPalette.white.withValues(alpha: 0.9)
        : colors.primaryText;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RouteConstants.routeAddressBookScreen);
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          SvgPicture.asset(
            MedpikSvgAssets.locationPin,
            width: 32.w,
            height: 32.w,
          ),

          Text(
            deliveryHint,
            style: FontPalette.base700(13, color: textColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Icon(Icons.keyboard_arrow_down_rounded, size: 20.r, color: textColor),
        ],
      ),
    );
  }
}

class HomeHeaderSearchRow extends StatelessWidget {
  const HomeHeaderSearchRow({
    super.key,
    required this.searchController,
    required this.onSearchTap,
    this.compact = false,
  });

  final TextEditingController searchController;
  final VoidCallback onSearchTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSearchTap,
      behavior: HitTestBehavior.opaque,
      child: IgnorePointer(
        child: CommonSearchBar(
          controller: searchController,
          hintText: Strings.searchMedicinesHealthcare,
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: compact ? 10.h : 12.h,
            ),
            child: SvgPicture.asset(
              MedpikSvgAssets.search,
              width: 24.w,
              height: 24.w,
            ),
          ),
        ),
      ),
    );
  }
}

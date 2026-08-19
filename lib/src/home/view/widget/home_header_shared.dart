// lib/src/home/view/widget/home_header_shared.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medpik/res/constants/medpik_svg_assets.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/utils/common_widgets/common_search_bar.dart';
import 'package:medpik/utils/routes/route_constants.dart';

class HomeHeaderIconButton extends StatelessWidget {
  const HomeHeaderIconButton({
    super.key,
    required this.iconAsset,
    required this.onTap,
    required this.iconColor,
  });

  final String iconAsset;
  final VoidCallback onTap;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorPalette.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24.r),
        child: Ink(
          width: 45.r,
          height: 45.r,
          decoration: BoxDecoration(
            color: ColorPalette.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              iconAsset,
              width: 24.w,
              height: 24.w,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}

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
            MedpikSvgAssets.homeLocation,
            width: 32.w,
            height: 32.w,
          ),
          8.horizontalSpace,
          Expanded(
            child: Text(
              deliveryHint,
              style: FontPalette.base700(13, color: textColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(Icons.keyboard_arrow_down_rounded, size: 20.r, color: textColor),
        ],
      ),
    );
  }
}

class HomeHeaderSearchRow extends StatelessWidget {
  const HomeHeaderSearchRow({super.key, required this.onSearchTap});

  final VoidCallback onSearchTap;

  @override
  Widget build(BuildContext context) {
    return CommonSearchBar(
      readOnly: true,
      hintText: Strings.searchMedicinesHealthcare,
      onTap: onSearchTap,
    );
  }
}

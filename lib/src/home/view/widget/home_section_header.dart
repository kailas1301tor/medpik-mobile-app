// lib/src/home/view/widget/home_section_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';

class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({
    super.key,
    required this.title,
    this.onSeeAll,
    this.bottomPadding,
  });

  final String title;
  final VoidCallback? onSeeAll;
  final double? bottomPadding;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, bottomPadding ?? 8.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: FontPalette.base700(18, color: colors.primaryText),
            ),
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    Strings.seeAll,
                    style: FontPalette.base500(
                      13,
                      color: ColorPalette.productAccentTeal,
                    ),
                  ),
                  4.horizontalSpace,
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12.r,
                    color: ColorPalette.productAccentTeal,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

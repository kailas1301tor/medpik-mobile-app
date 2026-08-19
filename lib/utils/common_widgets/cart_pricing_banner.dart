// lib/utils/common_widgets/cart_pricing_banner.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/utils/common_widgets/common_container.dart';

class CartPricingBanner extends StatelessWidget {
  const CartPricingBanner({super.key, this.showBorder = true});

  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return CommonContainer(
      padding: EdgeInsets.all(14.r),
      borderRadius: 12.r,
      color: colors.bannerWarningBg,
      side: showBorder
          ? BorderSide(color: colors.bannerWarningBorder, width: 1.w)
          : BorderSide.none,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 20.r,
            color: colors.statusWarningText,
          ),
          10.horizontalSpace,
          Expanded(
            child: Text(
              Strings.cartPricingDisclaimer,
              style: FontPalette.base400(12, color: colors.secondaryText),
            ),
          ),
        ],
      ),
    );
  }
}

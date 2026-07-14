// lib/src/cart/view/widget/cart_pricing_banner.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';

class CartPricingBanner extends StatelessWidget {
  const CartPricingBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return CommonContainer(
      padding: EdgeInsets.all(14.r),
      borderRadius: 12.r,
      color: ColorPalette.orderBannerWarningBg,
      border: Border.all(color: ColorPalette.orderBannerWarningBorder),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 20.r,
            color: ColorPalette.orderStatusWarningText,
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

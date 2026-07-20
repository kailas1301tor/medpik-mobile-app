// lib/src/cart/view/widget/cart_pricing_banner_shimmer.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/utils/common_widgets/common_shimmer_box.dart';

class CartPricingBannerShimmer extends StatelessWidget {
  const CartPricingBannerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: ColorPalette.orderBannerWarningBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorPalette.orderBannerWarningBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonShimmerBox(
            height: 20.r,
            width: 20.r,
            borderRadius: 10.r,
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonShimmerBox(
                  height: 12.h,
                  width: double.infinity,
                  borderRadius: 6.r,
                ),
                6.verticalSpace,
                CommonShimmerBox(
                  height: 12.h,
                  width: 220.w,
                  borderRadius: 6.r,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

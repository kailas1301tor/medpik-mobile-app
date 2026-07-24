// lib/utils/common_widgets/cart_pricing_banner_shimmer.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/utils/common_widgets/common_shimmer_box.dart';

class CartPricingBannerShimmer extends StatelessWidget {
  const CartPricingBannerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: colors.bannerWarningBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.bannerWarningBorder, width: 1.w),
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

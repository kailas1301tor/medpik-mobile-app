// lib/src/checkout/view/widget/checkout_address_card_shimmer.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/utils/common_widgets/common_shimmer_box.dart';

class CheckoutAddressCardShimmer extends StatelessWidget {
  const CheckoutAddressCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
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
                  height: 14.h,
                  width: 72.w,
                  borderRadius: 6.r,
                ),
                6.verticalSpace,
                CommonShimmerBox(
                  height: 12.h,
                  width: double.infinity,
                  borderRadius: 6.r,
                ),
                4.verticalSpace,
                CommonShimmerBox(
                  height: 12.h,
                  width: 180.w,
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

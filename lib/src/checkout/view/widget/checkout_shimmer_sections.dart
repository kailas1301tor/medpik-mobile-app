// lib/src/checkout/view/widget/checkout_shimmer_sections.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/utils/common_widgets/common_shimmer_box.dart';

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

class CheckoutProductTileShimmer extends StatelessWidget {
  const CheckoutProductTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final imageSize = 64.r;

    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonShimmerBox(
            height: imageSize,
            width: imageSize,
            borderRadius: 10.r,
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonShimmerBox(
                  height: 14.h,
                  width: double.infinity,
                  borderRadius: 6.r,
                ),
                6.verticalSpace,
                CommonShimmerBox(
                  height: 12.h,
                  width: 56.w,
                  borderRadius: 6.r,
                ),
                4.verticalSpace,
                CommonShimmerBox(
                  height: 11.h,
                  width: 96.w,
                  borderRadius: 6.r,
                ),
                8.verticalSpace,
                Row(
                  children: [
                    CommonShimmerBox(
                      height: 22.h,
                      width: 36.w,
                      borderRadius: 999.r,
                    ),
                    const Spacer(),
                    CommonShimmerBox(
                      height: 14.h,
                      width: 120.w,
                      borderRadius: 6.r,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CheckoutBillSummaryShimmer extends StatelessWidget {
  const CheckoutBillSummaryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: [
          const CheckoutBillRowShimmer(),
          10.verticalSpace,
          const CheckoutBillRowShimmer(),
          12.verticalSpace,
          CommonShimmerBox(
            height: 1.h,
            width: double.infinity,
            borderRadius: 1.r,
          ),
          12.verticalSpace,
          Row(
            children: [
              CommonShimmerBox(
                height: 15.h,
                width: 88.w,
                borderRadius: 6.r,
              ),
              const Spacer(),
              CommonShimmerBox(
                height: 15.h,
                width: 140.w,
                borderRadius: 6.r,
              ),
            ],
          ),
          8.verticalSpace,
          CommonShimmerBox(
            height: 11.h,
            width: double.infinity,
            borderRadius: 6.r,
          ),
        ],
      ),
    );
  }
}

class CheckoutBillRowShimmer extends StatelessWidget {
  const CheckoutBillRowShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CommonShimmerBox(
          height: 13.h,
          width: 120.w,
          borderRadius: 6.r,
        ),
        const Spacer(),
        CommonShimmerBox(
          height: 13.h,
          width: 140.w,
          borderRadius: 6.r,
        ),
      ],
    );
  }
}

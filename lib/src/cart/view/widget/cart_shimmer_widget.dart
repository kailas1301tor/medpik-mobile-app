// lib/src/cart/view/widget/cart_shimmer_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/src/cart/view/widget/cart_pricing_banner_shimmer.dart';
import 'package:tsuite/utils/common_widgets/common_shimmer_box.dart';

class CartShimmerWidget extends StatelessWidget {
  const CartShimmerWidget({super.key});

  static const int _itemCount = 2;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CartPricingBannerShimmer(),
          20.verticalSpace,
          Row(
            children: [
              CommonShimmerBox(
                height: 16.h,
                width: 168.w,
                borderRadius: 6.r,
              ),
              const Spacer(),
              CommonShimmerBox(
                height: 14.h,
                width: 56.w,
                borderRadius: 6.r,
              ),
            ],
          ),
          12.verticalSpace,
          for (var i = 0; i < _itemCount; i++) ...[
            if (i > 0) 12.verticalSpace,
            const _CartItemCardShimmer(),
          ],
        ],
      ),
    );
  }
}

class _CartItemCardShimmer extends StatelessWidget {
  const _CartItemCardShimmer();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final imageSize = 72.r;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonShimmerBox(
            height: imageSize,
            width: imageSize,
            borderRadius: 12.r,
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
                  width: 48.w,
                  borderRadius: 6.r,
                ),
                12.verticalSpace,
                Align(
                  alignment: Alignment.centerRight,
                  child: CommonShimmerBox(
                    height: 32.h,
                    width: 96.w,
                    borderRadius: 999.r,
                  ),
                ),
              ],
            ),
          ),
          8.horizontalSpace,
          CommonShimmerBox(
            height: 22.r,
            width: 22.r,
            borderRadius: 11.r,
          ),
        ],
      ),
    );
  }
}

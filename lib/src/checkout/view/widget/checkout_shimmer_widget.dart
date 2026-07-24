// lib/src/checkout/view/widget/checkout_shimmer_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/utils/common_widgets/cart_pricing_banner_shimmer.dart';
import 'package:medpik/src/checkout/view/widget/checkout_address_card_shimmer.dart';
import 'package:medpik/src/checkout/view/widget/checkout_bill_summary_shimmer.dart';
import 'package:medpik/src/checkout/view/widget/checkout_product_tile_shimmer.dart';
import 'package:medpik/utils/common_widgets/common_shimmer_box.dart';

class CheckoutShimmerWidget extends StatelessWidget {
  const CheckoutShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      children: [
        Expanded(
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
            children: [
              const CartPricingBannerShimmer(),
              20.verticalSpace,
              CommonShimmerBox(
                height: 16.h,
                width: 220.w,
                borderRadius: 6.r,
              ),
              10.verticalSpace,
              CommonShimmerBox(
                height: 88.h,
                width: double.infinity,
                borderRadius: 14.r,
              ),
              20.verticalSpace,
              Row(
                children: [
                  CommonShimmerBox(
                    height: 16.h,
                    width: 120.w,
                    borderRadius: 6.r,
                  ),
                  const Spacer(),
                  CommonShimmerBox(
                    height: 14.h,
                    width: 52.w,
                    borderRadius: 6.r,
                  ),
                ],
              ),
              10.verticalSpace,
              const CheckoutAddressCardShimmer(),
              20.verticalSpace,
              CommonShimmerBox(
                height: 16.h,
                width: 180.w,
                borderRadius: 6.r,
              ),
              12.verticalSpace,
              for (var i = 0; i < 2; i++)
                CheckoutProductTileShimmer(showDivider: i < 1),
              20.verticalSpace,
              CommonShimmerBox(
                height: 16.h,
                width: 120.w,
                borderRadius: 6.r,
              ),
              10.verticalSpace,
              const CheckoutBillSummaryShimmer(),
            ],
          ),
        ),
        ColoredBox(
          color: colors.surface,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: colors.divider)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h),
                child: CommonShimmerBox(
                  height: 48.h,
                  width: double.infinity,
                  borderRadius: 999.r,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

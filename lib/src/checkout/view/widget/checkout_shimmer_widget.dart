// lib/src/checkout/view/widget/checkout_shimmer_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/utils/common_widgets/cart_pricing_banner_shimmer.dart';
import 'package:medpik/src/checkout/view/widget/checkout_address_card_shimmer.dart';
import 'package:medpik/src/checkout/view/widget/checkout_bill_summary_shimmer.dart';
import 'package:medpik/src/checkout/view/widget/checkout_product_tile_shimmer.dart';
import 'package:medpik/src/checkout/view/widget/checkout_section_card.dart';
import 'package:medpik/utils/common_widgets/common_shimmer_box.dart';

class CheckoutShimmerWidget extends StatelessWidget {
  const CheckoutShimmerWidget({super.key, required this.itemCount});

  final int itemCount;

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
              16.verticalSpace,
              CheckoutSectionCard(
                titleIcon: Icons.local_pharmacy_outlined,
                title: Strings.addInstructionsForPharmacist,
                child: CommonShimmerBox(
                  height: 92.h,
                  width: double.infinity,
                  borderRadius: 16.r,
                ),
              ),
              16.verticalSpace,
              const CheckoutAddressCardShimmer(),
              16.verticalSpace,
              CheckoutSectionCard(
                titleIcon: Icons.medication_liquid_rounded,
                title: Strings.selectedMedicinesWithCount(itemCount),
                padding: EdgeInsets.fromLTRB(16.r, 16.r, 16.r, 4.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < 3; i++)
                      CheckoutProductTileShimmer(showDivider: i < 2),
                  ],
                ),
              ),
              16.verticalSpace,
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

// lib/src/checkout/view/widget/checkout_bill_summary_shimmer.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/src/checkout/view/widget/checkout_section_card.dart';
import 'package:medpik/utils/common_widgets/common_shimmer_box.dart';

class CheckoutBillSummaryShimmer extends StatelessWidget {
  const CheckoutBillSummaryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CheckoutSectionCard(
      title: Strings.orderSummary,
      titleIcon: Icons.receipt_long_rounded,
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
              CommonShimmerBox(height: 15.h, width: 88.w, borderRadius: 6.r),
              const Spacer(),
              CommonShimmerBox(height: 15.h, width: 140.w, borderRadius: 6.r),
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
        CommonShimmerBox(height: 13.h, width: 120.w, borderRadius: 6.r),
        const Spacer(),
        CommonShimmerBox(height: 13.h, width: 140.w, borderRadius: 6.r),
      ],
    );
  }
}

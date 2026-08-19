// lib/src/checkout/view/widget/checkout_address_card_shimmer.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/src/checkout/view/widget/checkout_section_card.dart';
import 'package:medpik/utils/common_widgets/common_shimmer_box.dart';

class CheckoutAddressCardShimmer extends StatelessWidget {
  const CheckoutAddressCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CheckoutSectionCard(
      title: Strings.deliveryAddress,
      titleIcon: Icons.location_on_rounded,
      trailing: CommonShimmerBox(
        height: 14.h,
        width: 54.w,
        borderRadius: 999.r,
      ),
      child: Row(
        children: [
          CommonShimmerBox(height: 20.r, width: 20.r, borderRadius: 10.r),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonShimmerBox(height: 14.h, width: 72.w, borderRadius: 6.r),
                6.verticalSpace,
                CommonShimmerBox(
                  height: 12.h,
                  width: double.infinity,
                  borderRadius: 6.r,
                ),
                4.verticalSpace,
                CommonShimmerBox(height: 12.h, width: 180.w, borderRadius: 6.r),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

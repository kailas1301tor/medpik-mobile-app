// lib/src/address/view/widget/location_confirm_address_shimmer.dart
//
// ? Skeleton lines in [LocationConfirmCard] while reverse geocode is loading.
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/utils/common_widgets/common_shimmer_box.dart';

class LocationConfirmAddressShimmer extends StatelessWidget {
  const LocationConfirmAddressShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonShimmerBox(
          height: 12.h,
          width: 96.w,
          borderRadius: 6.r,
        ),
        8.verticalSpace,
        CommonShimmerBox(
          height: 15.h,
          width: double.infinity,
          borderRadius: 6.r,
        ),
        6.verticalSpace,
        CommonShimmerBox(
          height: 15.h,
          width: 220.w,
          borderRadius: 6.r,
        ),
      ],
    );
  }
}

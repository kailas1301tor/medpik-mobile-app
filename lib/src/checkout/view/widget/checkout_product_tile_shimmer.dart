// lib/src/checkout/view/widget/checkout_product_tile_shimmer.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/utils/common_widgets/common_shimmer_box.dart';

class CheckoutProductTileShimmer extends StatelessWidget {
  const CheckoutProductTileShimmer({super.key, this.showDivider = true});

  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final imageSize = 56.r;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonShimmerBox(
                height: imageSize,
                width: imageSize,
                borderRadius: 10.r,
              ),
              10.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CommonShimmerBox(
                            height: 13.h,
                            width: double.infinity,
                            borderRadius: 6.r,
                          ),
                        ),
                        8.horizontalSpace,
                        CommonShimmerBox(
                          height: 20.h,
                          width: 28.w,
                          borderRadius: 6.r,
                        ),
                      ],
                    ),
                    2.verticalSpace,
                    CommonShimmerBox(
                      height: 11.h,
                      width: 56.w,
                      borderRadius: 6.r,
                    ),
                    2.verticalSpace,
                    CommonShimmerBox(
                      height: 11.h,
                      width: 96.w,
                      borderRadius: 6.r,
                    ),
                    6.verticalSpace,
                    Align(
                      alignment: Alignment.centerRight,
                      child: CommonShimmerBox(
                        height: 11.h,
                        width: 140.w,
                        borderRadius: 6.r,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1.h,
            thickness: 1,
            color: colors.divider,
          ),
      ],
    );
  }
}

// lib/src/prescription/view/widget/prescription_checkout_shimmer_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/utils/common_widgets/common_shimmer_box.dart';

class PrescriptionCheckoutShimmerWidget extends StatelessWidget {
  const PrescriptionCheckoutShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      children: [
        Expanded(
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            children: [
              CommonShimmerBox(
                height: 16.h,
                width: 140.w,
                borderRadius: 6.r,
              ),
              12.verticalSpace,
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonShimmerBox(
                      height: 22.r,
                      width: 22.r,
                      borderRadius: 11.r,
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonShimmerBox(
                            height: 16.h,
                            width: 100.w,
                            borderRadius: 6.r,
                          ),
                          8.verticalSpace,
                          CommonShimmerBox(
                            height: 12.h,
                            width: double.infinity,
                            borderRadius: 6.r,
                          ),
                          6.verticalSpace,
                          CommonShimmerBox(
                            height: 12.h,
                            width: 180.w,
                            borderRadius: 6.r,
                          ),
                        ],
                      ),
                    ),
                    8.horizontalSpace,
                    CommonShimmerBox(
                      height: 14.h,
                      width: 56.w,
                      borderRadius: 6.r,
                    ),
                  ],
                ),
              ),
              24.verticalSpace,
              CommonShimmerBox(
                height: 16.h,
                width: 130.w,
                borderRadius: 6.r,
              ),
              12.verticalSpace,
              Row(
                children: [
                  CommonShimmerBox(
                    height: 72.r,
                    width: 72.r,
                    borderRadius: 12.r,
                  ),
                  8.horizontalSpace,
                  CommonShimmerBox(
                    height: 72.r,
                    width: 72.r,
                    borderRadius: 12.r,
                  ),
                ],
              ),
              20.verticalSpace,
              CommonShimmerBox(
                height: 15.h,
                width: 160.w,
                borderRadius: 6.r,
              ),
              12.verticalSpace,
              for (var i = 0; i < 3; i++) ...[
                if (i > 0) 10.verticalSpace,
                const _ProductRowShimmer(),
              ],
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
          decoration: BoxDecoration(
            color: colors.surface,
            boxShadow: [
              BoxShadow(
                color: colors.primaryText.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: CommonShimmerBox(
            height: 48.h,
            width: double.infinity,
            borderRadius: 12.r,
          ),
        ),
      ],
    );
  }
}

class _ProductRowShimmer extends StatelessWidget {
  const _ProductRowShimmer();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          CommonShimmerBox(
            height: 48.r,
            width: 48.r,
            borderRadius: 8.r,
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
                  width: 120.w,
                  borderRadius: 6.r,
                ),
              ],
            ),
          ),
          8.horizontalSpace,
          CommonShimmerBox(
            height: 14.h,
            width: 28.w,
            borderRadius: 6.r,
          ),
        ],
      ),
    );
  }
}

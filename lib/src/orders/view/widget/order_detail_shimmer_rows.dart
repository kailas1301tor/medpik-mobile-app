// lib/src/orders/view/widget/order_detail_shimmer_rows.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/utils/common_widgets/common_shimmer_box.dart';

class OrderIdShimmerBlock extends StatelessWidget {
  const OrderIdShimmerBlock({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonShimmerBox(height: 12.h, width: 72.w),
        5.verticalSpace,
        CommonShimmerBox(height: 18.h, width: 220.w, borderRadius: 7.r),
      ],
    );
  }
}

class OrderStepperShimmer extends StatelessWidget {
  const OrderStepperShimmer({super.key});

  static const int _stepCount = 5;
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      children: [
        for (var i = 0; i < _stepCount; i++) ...[
          Expanded(
            child: Column(
              children: [
                CommonShimmerBox(
                  height: 40.r,
                  width: 40.r,
                  borderRadius: 999.r,
                ),
                8.verticalSpace,
                CommonShimmerBox(
                  height: 10.h,
                  width: 54.w,
                  borderRadius: 999.r,
                ),
              ],
            ),
          ),
          if (i < _stepCount - 1)
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: 26.h),
                child: Divider(
                  height: 1.h,
                  thickness: 3.h,
                  color: colors.divider.withValues(alpha: 0.8),
                ),
              ),
            ),
        ],
      ],
    );
  }
}

class OrderItemShimmer extends StatelessWidget {
  const OrderItemShimmer({super.key, required this.showDivider});

  final bool showDivider;
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonShimmerBox(height: 56.r, width: 56.r, borderRadius: 10.r),
              12.horizontalSpace,
              const Expanded(child: _ItemTextShimmer()),
              8.horizontalSpace,
              CommonShimmerBox(height: 16.h, width: 46.w, borderRadius: 7.r),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1.h,
            thickness: 1,
            color: colors.divider.withValues(alpha: 0.7),
          ),
      ],
    );
  }
}

class TwoLineContentShimmer extends StatelessWidget {
  const TwoLineContentShimmer({
    super.key,
    required this.width,
    this.showTotal = false,
  });

  final double width;
  final bool showTotal;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonShimmerBox(height: 14.h, width: width.w, borderRadius: 6.r),
        8.verticalSpace,
        CommonShimmerBox(height: 12.h, width: double.infinity),
        8.verticalSpace,
        Row(
          children: [
            CommonShimmerBox(height: 12.h, width: 132.w),
            const Spacer(),
            if (showTotal)
              CommonShimmerBox(height: 18.h, width: 72.w, borderRadius: 7.r),
          ],
        ),
      ],
    );
  }
}

class _ItemTextShimmer extends StatelessWidget {
  const _ItemTextShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonShimmerBox(height: 14.h, width: double.infinity),
        6.verticalSpace,
        CommonShimmerBox(height: 12.h, width: 72.w),
        6.verticalSpace,
        CommonShimmerBox(height: 12.h, width: 48.w),
      ],
    );
  }
}

// lib/src/prescription/view/widget/prescription_products_shimmer_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/utils/common_widgets/common_shimmer_box.dart';

class PrescriptionProductsShimmerWidget extends StatelessWidget {
  const PrescriptionProductsShimmerWidget({super.key});

  static const int _rowCount = 2;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var row = 0; row < _rowCount; row++) ...[
          if (row > 0) 8.verticalSpace,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(child: _ProductCardShimmer()),
              8.horizontalSpace,
              const Expanded(child: _ProductCardShimmer()),
              8.horizontalSpace,
              const Expanded(child: _ProductCardShimmer()),
            ],
          ),
        ],
      ],
    );
  }
}

class PrescriptionProductsLoadMoreShimmer extends StatelessWidget {
  const PrescriptionProductsLoadMoreShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: CommonShimmerBox(
        height: 36.h,
        width: double.infinity,
        borderRadius: 12.r,
      ),
    );
  }
}

class _ProductCardShimmer extends StatelessWidget {
  const _ProductCardShimmer();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonShimmerBox(
            height: 72.h,
            width: double.infinity,
            borderRadius: 14.r,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonShimmerBox(
                  height: 10.h,
                  width: double.infinity,
                  borderRadius: 4.r,
                ),
                6.verticalSpace,
                CommonShimmerBox(
                  height: 10.h,
                  width: 48.w,
                  borderRadius: 4.r,
                ),
                8.verticalSpace,
                CommonShimmerBox(
                  height: 24.h,
                  width: double.infinity,
                  borderRadius: 8.r,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

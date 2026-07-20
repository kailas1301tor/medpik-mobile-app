// lib/src/orders/view/widget/order_detail_shimmer_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';
import 'package:tsuite/utils/common_widgets/common_shimmer_box.dart';

class OrderDetailShimmerWidget extends StatelessWidget {
  const OrderDetailShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return ListView(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        CommonContainer(
          padding: EdgeInsets.all(16.r),
          borderRadius: 16.r,
          color: colors.surface,
          side: BorderSide(color: colors.cardBorder, width: 1.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonShimmerBox(height: 18.h, width: 140.w, borderRadius: 6.r),
              10.verticalSpace,
              CommonShimmerBox(height: 12.h, width: 180.w, borderRadius: 6.r),
              8.verticalSpace,
              CommonShimmerBox(height: 12.h, width: 100.w, borderRadius: 6.r),
            ],
          ),
        ),
        16.verticalSpace,
        CommonShimmerBox(height: 52.h, borderRadius: 12.r),
        20.verticalSpace,
        CommonContainer(
          padding: EdgeInsets.all(16.r),
          borderRadius: 16.r,
          color: colors.surface,
          side: BorderSide(color: colors.cardBorder, width: 1.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonShimmerBox(height: 14.h, width: 120.w, borderRadius: 6.r),
              12.verticalSpace,
              CommonShimmerBox(height: 12.h, borderRadius: 6.r),
              6.verticalSpace,
              CommonShimmerBox(height: 12.h, width: 200.w, borderRadius: 6.r),
              6.verticalSpace,
              CommonShimmerBox(height: 12.h, width: 140.w, borderRadius: 6.r),
            ],
          ),
        ),
        20.verticalSpace,
        CommonShimmerBox(height: 16.h, width: 120.w, borderRadius: 6.r),
        12.verticalSpace,
        ...List.generate(
          3,
          (_) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: CommonContainer(
              padding: EdgeInsets.all(12.r),
              borderRadius: 12.r,
              color: colors.surface,
              side: BorderSide(color: colors.cardBorder, width: 1.w),
              child: Row(
                children: [
                  CommonShimmerBox(
                    height: 56.r,
                    width: 56.r,
                    borderRadius: 10.r,
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonShimmerBox(
                          height: 14.h,
                          borderRadius: 6.r,
                        ),
                        8.verticalSpace,
                        CommonShimmerBox(
                          height: 12.h,
                          width: 80.w,
                          borderRadius: 6.r,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

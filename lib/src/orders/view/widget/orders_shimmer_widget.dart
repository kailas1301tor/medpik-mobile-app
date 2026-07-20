// lib/src/orders/view/widget/orders_shimmer_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';
import 'package:tsuite/utils/common_widgets/common_shimmer_box.dart';

class OrdersShimmerWidget extends StatelessWidget {
  const OrdersShimmerWidget({super.key});

  static const int _itemCount = 4;
  static const int _previewCount = 4;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _itemCount,
      itemBuilder: (context, index) {
        return CommonContainer(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.r),
          borderRadius: 16.r,
          color: colors.surface,
          side: BorderSide(color: colors.cardBorder, width: 1.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CommonShimmerBox(
                      height: 16.h,
                      width: 160.w,
                      borderRadius: 6.r,
                    ),
                  ),
                  CommonShimmerBox(
                    height: 24.h,
                    width: 72.w,
                    borderRadius: 8.r,
                  ),
                  8.horizontalSpace,
                  CommonShimmerBox(
                    height: 18.r,
                    width: 18.r,
                    borderRadius: 9.r,
                  ),
                ],
              ),
              10.verticalSpace,
              CommonShimmerBox(height: 12.h, width: 140.w, borderRadius: 6.r),
              6.verticalSpace,
              CommonShimmerBox(height: 12.h, width: 80.w, borderRadius: 6.r),
              12.verticalSpace,
              Row(
                children: List.generate(
                  _previewCount,
                  (previewIndex) => Padding(
                    padding: EdgeInsets.only(
                      right: previewIndex == _previewCount - 1 ? 0 : 8.w,
                    ),
                    child: CommonShimmerBox(
                      height: 40.r,
                      width: 40.r,
                      borderRadius: 8.r,
                    ),
                  ),
                ),
              ),
              12.verticalSpace,
              Row(
                children: [
                  CommonShimmerBox(
                    height: 12.h,
                    width: 64.w,
                    borderRadius: 6.r,
                  ),
                  8.horizontalSpace,
                  CommonShimmerBox(
                    height: 22.h,
                    width: 88.w,
                    borderRadius: 8.r,
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CommonShimmerBox(
                        height: 10.h,
                        width: 36.w,
                        borderRadius: 4.r,
                      ),
                      4.verticalSpace,
                      CommonShimmerBox(
                        height: 14.h,
                        width: 56.w,
                        borderRadius: 6.r,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

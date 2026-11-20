// lib/src/orders/view/widget/orders_shimmer_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/utils/common_widgets/common_container.dart';
import 'package:medpik/utils/common_widgets/common_shimmer_box.dart';
import 'package:medpik/utils/helpers/shell_insets_helper.dart';

class OrdersShimmerWidget extends StatelessWidget {
  const OrdersShimmerWidget({super.key});

  static const int _itemCount = 4;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
        16.w,
        0,
        16.w,
        shellScrollBottomPadding(context),
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _itemCount,
      itemBuilder: (context, index) {
        return CommonContainer(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(14.r),
          borderRadius: 24.r,
          color: colors.surface,
          side: BorderSide(color: colors.cardBorder, width: 1.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonShimmerBox(
                    height: 72.r,
                    width: 72.r,
                    borderRadius: 18.r,
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonShimmerBox(
                          height: 10.h,
                          width: 64.w,
                          borderRadius: 4.r,
                        ),
                        6.verticalSpace,
                        CommonShimmerBox(
                          height: 16.h,
                          width: 140.w,
                          borderRadius: 6.r,
                        ),
                      ],
                    ),
                  ),
                  CommonShimmerBox(
                    height: 24.h,
                    width: 72.w,
                    borderRadius: 999.r,
                  ),
                ],
              ),
              14.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: CommonShimmerBox(
                      height: 32.h,
                      borderRadius: 8.r,
                    ),
                  ),
                  8.horizontalSpace,
                  Expanded(
                    child: CommonShimmerBox(
                      height: 32.h,
                      borderRadius: 8.r,
                    ),
                  ),
                  8.horizontalSpace,
                  Expanded(
                    child: CommonShimmerBox(
                      height: 32.h,
                      borderRadius: 8.r,
                    ),
                  ),
                ],
              ),
              12.verticalSpace,
              CommonShimmerBox(height: 1.h, borderRadius: 1.r),
              12.verticalSpace,
              Row(
                children: [
                  CommonShimmerBox(
                    height: 28.h,
                    width: 88.w,
                    borderRadius: 999.r,
                  ),
                  const Spacer(),
                  CommonShimmerBox(
                    height: 28.h,
                    width: 64.w,
                    borderRadius: 6.r,
                  ),
                  10.horizontalSpace,
                  CommonShimmerBox(
                    height: 36.r,
                    width: 36.r,
                    borderRadius: 18.r,
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

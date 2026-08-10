// lib/src/cart/view/widget/cart_shimmer_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/utils/common_widgets/common_shimmer_box.dart';

class CartShimmerWidget extends StatelessWidget {
  const CartShimmerWidget({super.key});

  static const int _itemCount = 2;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
      children: [
        Row(
          children: [
            CommonShimmerBox(height: 16.h, width: 168.w, borderRadius: 6.r),
            const Spacer(),
            CommonShimmerBox(height: 14.h, width: 56.w, borderRadius: 6.r),
          ],
        ),
        8.verticalSpace,
        for (var i = 0; i < _itemCount; i++)
          _CartItemRowShimmer(showDivider: i < _itemCount - 1),
      ],
    );
  }
}

class _CartItemRowShimmer extends StatelessWidget {
  const _CartItemRowShimmer({required this.showDivider});

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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonShimmerBox(
                      height: 13.h,
                      width: double.infinity,
                      borderRadius: 6.r,
                    ),
                    2.verticalSpace,
                    CommonShimmerBox(
                      height: 11.h,
                      width: 48.w,
                      borderRadius: 6.r,
                    ),
                  ],
                ),
              ),
              8.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CommonShimmerBox(
                    height: 18.r,
                    width: 18.r,
                    borderRadius: 9.r,
                  ),
                  6.verticalSpace,
                  CommonShimmerBox(
                    height: 28.h,
                    width: 72.w,
                    borderRadius: 8.r,
                  ),
                ],
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(height: 1.h, thickness: 1, color: colors.divider),
      ],
    );
  }
}

// lib/src/product_detail/view/widget/product_detail_footer_shimmer.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/utils/common_widgets/common_shimmer_box.dart';

class ProductDetailFooterShimmer extends StatelessWidget {
  const ProductDetailFooterShimmer({super.key, required this.bottomInset});

  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: [
          BoxShadow(
            color: ColorPalette.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: Offset(0, -4.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h + bottomInset),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonShimmerBox(height: 12.h, width: 56.w, borderRadius: 6.r),
                6.verticalSpace,
                CommonShimmerBox(
                  height: 48.h,
                  width: 110.w,
                  borderRadius: 14.r,
                ),
              ],
            ),
            16.horizontalSpace,
            Expanded(
              child: CommonShimmerBox(
                height: 48.h,
                width: double.infinity,
                borderRadius: 14.r,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

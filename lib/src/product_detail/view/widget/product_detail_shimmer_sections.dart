// lib/src/product_detail/view/widget/product_detail_shimmer_sections.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/utils/common_widgets/common_shimmer_box.dart';

class ProductDetailSheetBodyShimmer extends StatelessWidget {
  const ProductDetailSheetBodyShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonShimmerBox(height: 24.h, width: 240.w, borderRadius: 8.r),
        10.verticalSpace,
        CommonShimmerBox(height: 14.h, width: 120.w, borderRadius: 6.r),
        10.verticalSpace,
        CommonShimmerBox(height: 13.h, width: 180.w, borderRadius: 6.r),
        12.verticalSpace,
        Row(
          children: [
            CommonShimmerBox(height: 28.h, width: 72.w, borderRadius: 999.r),
            8.horizontalSpace,
            CommonShimmerBox(height: 28.h, width: 88.w, borderRadius: 999.r),
            8.horizontalSpace,
            CommonShimmerBox(height: 28.h, width: 96.w, borderRadius: 999.r),
          ],
        ),
        28.verticalSpace,
        CommonShimmerBox(height: 18.h, width: 160.w, borderRadius: 8.r),
        12.verticalSpace,
        CommonShimmerBox(
          height: 14.h,
          width: double.infinity,
          borderRadius: 6.r,
        ),
        8.verticalSpace,
        CommonShimmerBox(
          height: 14.h,
          width: double.infinity,
          borderRadius: 6.r,
        ),
        8.verticalSpace,
        CommonShimmerBox(height: 14.h, width: 200.w, borderRadius: 6.r),
      ],
    );
  }
}

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
                CommonShimmerBox(height: 48.h, width: 110.w, borderRadius: 14.r),
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

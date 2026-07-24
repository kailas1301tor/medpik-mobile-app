// lib/src/home/view/widget/home_shimmer_sections.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/utils/common_widgets/common_shimmer_box.dart';

class HomeCategoryShimmerRow extends StatelessWidget {
  const HomeCategoryShimmerRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          for (var i = 0; i < 5; i++) ...[
            if (i > 0) 16.horizontalSpace,
            SizedBox(
              width: 72.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CommonShimmerBox(
                    height: 64.r,
                    width: 64.r,
                    borderRadius: 32.r,
                  ),
                  8.verticalSpace,
                  CommonShimmerBox(
                    height: 12.h,
                    width: 56.w,
                    borderRadius: 6.r,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class HomeProductGridShimmer extends StatelessWidget {
  const HomeProductGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 8.h),
      child: Column(
        children: [
          for (var row = 0; row < 2; row++) ...[
            if (row > 0) 12.verticalSpace,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(child: _ProductCardShimmer()),
                12.horizontalSpace,
                const Expanded(child: _ProductCardShimmer()),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ProductCardShimmer extends StatelessWidget {
  const _ProductCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonShimmerBox(
          height: 118.h,
          width: double.infinity,
          borderRadius: 20.r,
        ),
        10.verticalSpace,
        CommonShimmerBox(
          height: 14.h,
          width: double.infinity,
          borderRadius: 6.r,
        ),
        6.verticalSpace,
        CommonShimmerBox(height: 12.h, width: 72.w, borderRadius: 6.r),
        8.verticalSpace,
        CommonShimmerBox(height: 16.h, width: 56.w, borderRadius: 6.r),
      ],
    );
  }
}

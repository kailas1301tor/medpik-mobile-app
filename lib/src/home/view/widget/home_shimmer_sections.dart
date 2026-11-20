// lib/src/home/view/widget/home_shimmer_sections.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/src/home/view/widget/home_product_rail.dart';
import 'package:medpik/utils/common_widgets/common_shimmer_box.dart';

class HomePrescriptionCardShimmer extends StatelessWidget {
  const HomePrescriptionCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
      child: CommonShimmerBox(
        height: 168.h,
        width: double.infinity,
        borderRadius: 24.r,
      ),
    );
  }
}

class HomeOfferCarouselShimmer extends StatelessWidget {
  const HomeOfferCarouselShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: CommonShimmerBox(
        height: 160.h,
        width: double.infinity,
        borderRadius: 20.r,
      ),
    );
  }
}

class HomeCategoryShimmerRow extends StatelessWidget {
  const HomeCategoryShimmerRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const crossAxisCount = 4;
          final gap = 8.w;
          final itemWidth =
              (constraints.maxWidth - gap * (crossAxisCount - 1)) /
                  crossAxisCount;

          return Wrap(
            spacing: gap,
            runSpacing: 12.h,
            children: [
              for (var i = 0; i < 8; i++)
                SizedBox(
                  width: itemWidth,
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
          );
        },
      ),
    );
  }
}

class HomeProductRailShimmer extends StatelessWidget {
  const HomeProductRailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: HomeProductRail.height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 8.h),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: index < 3 ? 12.w : 0),
            child: SizedBox(
              width: 148.w,
              child: const _ProductCardShimmer(),
            ),
          );
        },
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

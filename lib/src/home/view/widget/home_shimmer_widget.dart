// lib/src/home/view/widget/home_shimmer_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/utils/common_widgets/common_shimmer_box.dart';

class HomeShimmerWidget extends StatelessWidget {
  const HomeShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            height: topInset + 220.h,
            color: ColorPalette.primaryColorDark,
            padding: EdgeInsets.fromLTRB(16.w, topInset + 16.h, 16.w, 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonShimmerBox(height: 24.h, width: 180.w, borderRadius: 8.r),
                12.verticalSpace,
                CommonShimmerBox(height: 18.h, width: 200.w, borderRadius: 8.r),
                20.verticalSpace,
                CommonShimmerBox(
                  height: 48.h,
                  width: double.infinity,
                  borderRadius: 24.r,
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonShimmerBox(
                  height: 136.h,
                  width: double.infinity,
                  borderRadius: 20.r,
                ),
                16.verticalSpace,
                CommonShimmerBox(
                  height: 20.h,
                  width: 140.w,
                  borderRadius: 8.r,
                ),
                8.verticalSpace,
                CommonShimmerBox(
                  height: 148.h,
                  width: double.infinity,
                  borderRadius: 20.r,
                ),
                16.verticalSpace,
                CommonShimmerBox(
                  height: 20.h,
                  width: 160.w,
                  borderRadius: 8.r,
                ),
                8.verticalSpace,
                SizedBox(
                  height: 112.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    separatorBuilder: (_, __) => 16.horizontalSpace,
                    itemBuilder:
                        (_, __) => CommonShimmerBox(
                          height: 64.r,
                          width: 64.r,
                          borderRadius: 32.r,
                        ),
                  ),
                ),
                16.verticalSpace,
                CommonShimmerBox(
                  height: 20.h,
                  width: 160.w,
                  borderRadius: 8.r,
                ),
                8.verticalSpace,
                SizedBox(
                  height: 220.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: 3,
                    separatorBuilder: (_, __) => 12.horizontalSpace,
                    itemBuilder:
                        (_, __) => CommonShimmerBox(
                          height: 212.h,
                          width: 165.w,
                          borderRadius: 16.r,
                        ),
                  ),
                ),
                80.verticalSpace,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

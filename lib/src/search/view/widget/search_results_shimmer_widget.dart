// lib/src/search/view/widget/search_results_shimmer_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/utils/common_widgets/common_container.dart';
import 'package:medpik/utils/common_widgets/common_shimmer_box.dart';

class SearchResultsShimmerWidget extends StatelessWidget {
  const SearchResultsShimmerWidget({super.key});

  static const int _rowCount = 3;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _rowCount,
      itemBuilder: (context, rowIndex) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: rowIndex < _rowCount - 1 ? 12.h : 0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(child: _ProductCardShimmer()),
              12.horizontalSpace,
              const Expanded(child: _ProductCardShimmer()),
            ],
          ),
        );
      },
    );
  }
}

class SearchResultsLoadMoreShimmer extends StatelessWidget {
  const SearchResultsLoadMoreShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: CommonShimmerBox(
        height: 36.h,
        width: 120.w,
        borderRadius: 18.r,
      ),
    );
  }
}

class _ProductCardShimmer extends StatelessWidget {
  const _ProductCardShimmer();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return CommonContainer(
      borderRadius: 20.r,
      color: colors.cardBackground,
      side: BorderSide(color: colors.cardBorder),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonShimmerBox(
            height: 118.h,
            width: double.infinity,
            borderRadius: 20.r,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonShimmerBox(
                  height: 14.h,
                  width: double.infinity,
                  borderRadius: 6.r,
                ),
                6.verticalSpace,
                CommonShimmerBox(
                  height: 20.h,
                  width: 64.w,
                  borderRadius: 999.r,
                ),
                6.verticalSpace,
                CommonShimmerBox(
                  height: 12.h,
                  width: 48.w,
                  borderRadius: 6.r,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

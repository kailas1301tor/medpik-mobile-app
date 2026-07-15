// lib/src/wishlist/view/widget/wishlist_shimmer_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/utils/common_widgets/common_shimmer_box.dart';

class WishlistShimmerWidget extends StatelessWidget {
  const WishlistShimmerWidget({super.key});

  static const int _rowCount = 3;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
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
              const Expanded(child: _WishlistCardShimmer()),
              12.horizontalSpace,
              const Expanded(child: _WishlistCardShimmer()),
            ],
          ),
        );
      },
    );
  }
}

class _WishlistCardShimmer extends StatelessWidget {
  const _WishlistCardShimmer();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final radius = 20.r;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: colors.cardBorder, width: 1),
      ),
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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonShimmerBox(
                  height: 14.h,
                  width: double.infinity,
                  borderRadius: 6.r,
                ),
                6.verticalSpace,
                CommonShimmerBox(
                  height: 14.h,
                  width: 100.w,
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
                  width: 72.w,
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

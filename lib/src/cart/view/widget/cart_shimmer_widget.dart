// lib/src/cart/view/widget/cart_shimmer_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/utils/common_widgets/common_shimmer_box.dart';

class CartShimmerWidget extends StatelessWidget {
  const CartShimmerWidget({super.key});

  static const int _itemCount = 6;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Row(
                children: [
                  CommonShimmerBox(
                    height: 18.h,
                    width: 174.w,
                    borderRadius: 7.r,
                  ),
                  const Spacer(),
                  CommonShimmerBox(
                    height: 14.h,
                    width: 62.w,
                    borderRadius: 999.r,
                  ),
                ],
              ),
              8.verticalSpace,
            ]),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
          sliver: SliverList.builder(
            itemCount: _itemCount,
            itemBuilder: (context, index) {
              return _CartItemRowShimmer(showDivider: index < _itemCount - 1);
            },
          ),
        ),
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
                    height: 30.r,
                    width: 30.r,
                    borderRadius: 999.r,
                  ),
                  8.verticalSpace,
                  const _QtySelectorShimmer(),
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

class _QtySelectorShimmer extends StatelessWidget {
  const _QtySelectorShimmer();

  @override
  Widget build(BuildContext context) {
    return CommonShimmerBox(height: 30.h, width: 92.w, borderRadius: 999.r);
  }
}

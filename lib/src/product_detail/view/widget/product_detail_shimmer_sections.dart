// lib/src/product_detail/view/widget/product_detail_shimmer_sections.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/utils/common_widgets/common_shimmer_box.dart';

class ProductDetailSheetBodyShimmer extends StatelessWidget {
  const ProductDetailSheetBodyShimmer({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonShimmerBox(height: 24.h, width: 240.w, borderRadius: 8.r),
        8.verticalSpace,
        CommonShimmerBox(height: 14.h, width: 120.w, borderRadius: 6.r),
        8.verticalSpace,
        CommonShimmerBox(height: 13.h, width: 210.w, borderRadius: 6.r),
        10.verticalSpace,
        Row(
          children: [
            CommonShimmerBox(height: 28.h, width: 72.w, borderRadius: 999.r),
            8.horizontalSpace,
            CommonShimmerBox(height: 28.h, width: 88.w, borderRadius: 999.r),
            8.horizontalSpace,
            CommonShimmerBox(height: 28.h, width: 96.w, borderRadius: 999.r),
          ],
        ),
        10.verticalSpace,
        CommonShimmerBox(height: 12.h, width: 74.w, borderRadius: 6.r),
        10.verticalSpace,
        CommonShimmerBox(height: 40.h, width: 132.w, borderRadius: 999.r),
        24.verticalSpace,
        const _SectionTitleShimmer(width: 138),
        10.verticalSpace,
        CommonShimmerBox(height: 52.h, width: double.infinity),
        24.verticalSpace,
        const _SectionTitleShimmer(width: 112),
        12.verticalSpace,
        const _BenefitsRowShimmer(),
        24.verticalSpace,
        const _SectionTitleShimmer(width: 86),
        10.verticalSpace,
        const _InfoPanelShimmer(),
        24.verticalSpace,
        const _SectionTitleShimmer(width: 150),
        10.verticalSpace,
        const _InfoPanelShimmer(),
      ],
    );
  }
}

class _SectionTitleShimmer extends StatelessWidget {
  const _SectionTitleShimmer({required this.width});

  final double width;
  @override
  Widget build(BuildContext context) {
    return CommonShimmerBox(height: 18.h, width: width.w, borderRadius: 8.r);
  }
}

class _BenefitsRowShimmer extends StatelessWidget {
  const _BenefitsRowShimmer();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (_, __) => 10.horizontalSpace,
        itemBuilder: (_, __) => const _BenefitCardShimmer(),
      ),
    );
  }
}

class _BenefitCardShimmer extends StatelessWidget {
  const _BenefitCardShimmer();
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: 120.w,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonShimmerBox(height: 32.r, width: 32.r, borderRadius: 999.r),
          10.verticalSpace,
          CommonShimmerBox(height: 13.h, width: 74.w),
          8.verticalSpace,
          CommonShimmerBox(height: 11.h, width: double.infinity),
          6.verticalSpace,
          CommonShimmerBox(height: 11.h, width: 72.w),
        ],
      ),
    );
  }
}

class _InfoPanelShimmer extends StatelessWidget {
  const _InfoPanelShimmer();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: colors.bannerInfoBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.bannerInfoBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonShimmerBox(height: 20.r, width: 20.r, borderRadius: 6.r),
          10.horizontalSpace,
          const Expanded(child: _InfoTextLinesShimmer()),
        ],
      ),
    );
  }
}

class _InfoTextLinesShimmer extends StatelessWidget {
  const _InfoTextLinesShimmer();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonShimmerBox(height: 12.h, width: double.infinity),
        7.verticalSpace,
        CommonShimmerBox(height: 12.h, width: 180.w),
      ],
    );
  }
}

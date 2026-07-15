// lib/src/product_detail/view/widget/product_detail_benefits_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/product_detail/model/product_benefit_model.dart';
import 'package:tsuite/src/product_detail/model/product_detail_model.dart';
import 'package:tsuite/src/product_detail/view/widget/product_detail_icon_helper.dart';

class ProductDetailBenefitsSection extends StatelessWidget {
  const ProductDetailBenefitsSection({super.key, required this.detail});

  final ProductDetailModel detail;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (detail.keyBenefits.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.keyBenefits,
          style: FontPalette.base700(16, color: colors.primaryText),
        ),
        12.verticalSpace,
        SizedBox(
          height: 140.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: detail.keyBenefits.length,
            separatorBuilder: (_, __) => 10.horizontalSpace,
            itemBuilder: (context, index) {
              return _BenefitCard(benefit: detail.keyBenefits[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({required this.benefit});

  final ProductBenefitModel benefit;

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
          Container(
            width: 32.r,
            height: 32.r,
            decoration: BoxDecoration(
              color: ColorPalette.productAccentTeal.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: ProductDetailIconHelper.build(
              iconKey: benefit.iconKey,
              size: 16.r,
              color: ColorPalette.productAccentTeal,
            ),
          ),
          8.verticalSpace,
          Text(
            benefit.title,
            style: FontPalette.base600(13, color: colors.primaryText),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          4.verticalSpace,
          Expanded(
            child: Text(
              benefit.description,
              style: FontPalette.base400(11, color: colors.secondaryText),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

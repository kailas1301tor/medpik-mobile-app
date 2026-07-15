// lib/src/product_detail/view/widget/product_detail_title_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/product_detail/model/product_detail_model.dart';
import 'package:tsuite/utils/helpers/product_pack_label_helper.dart';

class ProductDetailTitleSection extends StatelessWidget {
  const ProductDetailTitleSection({super.key, required this.detail});

  final ProductDetailModel detail;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final product = detail.product;
    final packBadge = productPackBadgeLabel(product);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: FontPalette.base700(22, color: colors.primaryText),
        ),
        if (detail.specificationLabel.isNotEmpty) ...[
          6.verticalSpace,
          Text(
            detail.specificationLabel,
            style: FontPalette.base400(
              14,
              color: colors.secondaryText,
            ),
          ),
        ],
        10.verticalSpace,
        _CategoryChip(
          label: packBadge.isNotEmpty ? packBadge : product.category,
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: ColorPalette.productAccentTeal.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.medication_outlined,
            size: 12.r,
            color: ColorPalette.productAccentTeal,
          ),
          4.horizontalSpace,
          Text(
            label,
            style: FontPalette.base600(
              11,
              color: ColorPalette.productAccentTeal,
            ),
          ),
        ],
      ),
    );
  }
}

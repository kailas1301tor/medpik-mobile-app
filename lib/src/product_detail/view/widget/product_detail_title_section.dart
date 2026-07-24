// lib/src/product_detail/view/widget/product_detail_title_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/product_detail/model/product_detail_model.dart';
import 'package:medpik/utils/helpers/product_pack_label_helper.dart';

class ProductDetailTitleSection extends StatelessWidget {
  const ProductDetailTitleSection({super.key, required this.detail});

  final ProductDetailModel detail;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final product = detail.product;
    final packBadge = productPackBadgeLabel(product);
    final categoryLabel = product.category.trim();
    final typeLabel = product.requiresPrescription
        ? Strings.prescriptionMedicine
        : Strings.otcMedicine;

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
        if (product.manufacturerName.isNotEmpty) ...[
          8.verticalSpace,
          Text(
            '${Strings.manufacturer}: ${product.manufacturerName}',
            style: FontPalette.base400(
              13,
              color: colors.secondaryText,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        10.verticalSpace,
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            if (packBadge.isNotEmpty) _MetaChip(label: packBadge),
            if (categoryLabel.isNotEmpty) _MetaChip(label: categoryLabel),
            _MetaChip(label: typeLabel),
          ],
        ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label});

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

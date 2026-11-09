// lib/src/product_detail/view/widget/product_detail_title_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/product_detail/model/product_detail_model.dart';
import 'package:medpik/src/product_detail/notifier/product_detail_notifier.dart';
import 'package:medpik/utils/helpers/product_pack_label_helper.dart';

class ProductDetailTitleSection extends ConsumerWidget {
  const ProductDetailTitleSection({super.key, required this.detail});

  final ProductDetailModel detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final product = detail.product;
    final packBadge = productPackBadgeLabel(product);
    final categoryLabel = product.category.trim();
    final typeLabel = product.requiresPrescription
        ? Strings.prescriptionMedicine
        : Strings.otcMedicine;
    final packLabel = ref.watch(
      productDetailNotifierProvider.select((s) {
        final packagings = s.detail?.packagings ?? const [];
        if (packagings.isEmpty) return detail.packLabel;
        final index =
            s.selectedPackagingIndex.clamp(0, packagings.length - 1);
        final label = packagings[index].displayLabel;
        return label.isNotEmpty ? label : detail.packLabel;
      }),
    );
    final dosage = detail.dosage.trim();
    final specificationLabel = dosage.isEmpty
        ? packLabel
        : packLabel.isEmpty
            ? dosage
            : '$dosage • $packLabel';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: FontPalette.base700(22, color: colors.primaryText),
        ),
        if (specificationLabel.isNotEmpty) ...[
          6.verticalSpace,
          Text(
            specificationLabel,
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
            if (product.isDrugsetuProducts)
              const _MetaChip(label: Strings.drugsetuProduct),
            if (packBadge.isNotEmpty) _MetaChip(label: packBadge),
            if (categoryLabel.isNotEmpty) _MetaChip(label: categoryLabel),
            _MetaChip(label: typeLabel),
            if (product.productForm.trim().isNotEmpty)
              _MetaChip(label: product.productForm.trim()),
            if (detail.drugClass.trim().isNotEmpty)
              _MetaChip(label: detail.drugClass.trim()),
            if (detail.saltName.trim().isNotEmpty)
              _MetaChip(label: detail.saltName.trim()),
            if (detail.strength.trim().isNotEmpty)
              _MetaChip(label: detail.strength.trim()),
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

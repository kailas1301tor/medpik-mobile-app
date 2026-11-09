// lib/src/product_detail/view/widget/product_detail_packaging_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/product_detail/model/product_packaging_model.dart';
import 'package:medpik/src/product_detail/notifier/product_detail_notifier.dart';

class ProductDetailPackagingSection extends ConsumerWidget {
  const ProductDetailPackagingSection({
    super.key,
    required this.packagings,
  });

  final List<ProductPackagingModel> packagings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (packagings.isEmpty) return const SizedBox.shrink();

    final colors = context.appColors;
    final selectedIndex = ref.watch(
      productDetailNotifierProvider.select((s) => s.selectedPackagingIndex),
    );
    final notifier = ref.read(productDetailNotifierProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.verticalSpace,
        Text(
          Strings.selectPackaging,
          style: FontPalette.base500(12, color: colors.secondaryText),
        ),
        10.verticalSpace,
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: List.generate(packagings.length, (index) {
            final packaging = packagings[index];
            final label = packaging.displayLabel;
            if (label.isEmpty) return const SizedBox.shrink();
            final isSelected = index == selectedIndex;
            return _PackagingChip(
              label: label,
              isSelected: isSelected,
              onTap: () => notifier.selectPackaging(index),
            );
          }),
        ),
      ],
    );
  }
}

class _PackagingChip extends StatelessWidget {
  const _PackagingChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorPalette.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999.r),
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected
                ? ColorPalette.productAccentTeal.withValues(alpha: 0.14)
                : ColorPalette.productAccentTeal.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(
              color: isSelected
                  ? ColorPalette.productAccentTeal
                  : ColorPalette.productAccentTeal.withValues(alpha: 0.24),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Text(
            label,
            style: FontPalette.base600(
              12,
              color: ColorPalette.productAccentTeal,
            ),
          ),
        ),
      ),
    );
  }
}

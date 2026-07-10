// lib/src/prescription/view/widget/prescription_product_grid_add_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/prescription/notifier/prescription_notifier.dart';
import 'package:tsuite/src/prescription/view/widget/prescription_product_quantity_sheet.dart';

class PrescriptionProductGridAddButton extends ConsumerWidget {
  const PrescriptionProductGridAddButton({super.key, required this.product});

  final ProductModel product;

  int _quantity(WidgetRef ref) {
    return ref.watch(
      prescriptionNotifierProvider.select((s) {
        for (final item in s.selectedProducts) {
          if (item.product.id == product.id) return item.quantity;
        }
        return 0;
      }),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantity = _quantity(ref);

    return GestureDetector(
      onTap: () => PrescriptionProductQuantitySheet.show(
        context,
        ref,
        product: product,
      ),
      behavior: HitTestBehavior.opaque,
      child: quantity == 0
          ? Container(
              width: 26.r,
              height: 26.r,
              decoration: BoxDecoration(
                color: ColorPalette.productAccentTeal,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: ColorPalette.productAccentTeal.withValues(alpha: 0.28),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.add_rounded,
                size: 14.r,
                color: ColorPalette.white,
              ),
            )
          : Container(
              width: 26.r,
              height: 26.r,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ColorPalette.productAccentTeal,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: ColorPalette.productAccentTeal.withValues(alpha: 0.28),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '$quantity',
                style: FontPalette.base700(11, color: ColorPalette.white),
              ),
            ),
    );
  }
}

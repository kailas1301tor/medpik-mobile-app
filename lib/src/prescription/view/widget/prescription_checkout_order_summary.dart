// lib/src/prescription/view/widget/prescription_checkout_order_summary.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/data/models/prescription_selected_product_model.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/prescription/view/widget/prescription_checkout_files.dart';
import 'package:medpik/src/prescription/view/widget/prescription_checkout_product_tile.dart';

class PrescriptionCheckoutOrderSummary extends StatelessWidget {
  const PrescriptionCheckoutOrderSummary({
    super.key,
    required this.filePaths,
    required this.products,
  });

  final List<String> filePaths;
  final List<PrescriptionSelectedProductModel> products;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          Strings.orderSummary,
          style: FontPalette.base700(16, color: colors.primaryText),
        ),
        12.verticalSpace,
        if (filePaths.isNotEmpty)
          PrescriptionCheckoutFiles(filePaths: filePaths),
        if (products.isNotEmpty) ...[
          Text(
            Strings.prescriptionProducts,
            style: FontPalette.base700(15, color: colors.primaryText),
          ),
          12.verticalSpace,
          for (final item in products)
            PrescriptionCheckoutProductTile(item: item),
        ],
      ],
    );
  }
}

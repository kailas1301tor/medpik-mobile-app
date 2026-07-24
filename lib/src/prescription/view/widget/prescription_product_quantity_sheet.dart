// lib/src/prescription/view/widget/prescription_product_quantity_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/data/models/product_model.dart';
import 'package:medpik/data/models/prescription_selected_product_model.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/prescription/notifier/prescription_notifier.dart';
import 'package:medpik/utils/common_widgets/common_bottom_sheet.dart';
import 'package:medpik/utils/common_widgets/common_cached_network_image.dart';
import 'package:medpik/utils/common_widgets/common_text_form_field.dart';
import 'package:medpik/utils/common_widgets/primary_button.dart';

class PrescriptionProductQuantitySheet {
  PrescriptionProductQuantitySheet._();

  static Future<void> show(
    BuildContext context,
    WidgetRef ref, {
    required ProductModel product,
  }) {
    ref
        .read(prescriptionNotifierProvider.notifier)
        .prepareProductQuantityEditor(product.id);

    return CommonBottomSheet.show(
      context: context,
      title: Strings.selectQuantity,
      child: _PrescriptionProductQuantitySheetContent(product: product),
    );
  }
}

class _PrescriptionProductQuantitySheetContent extends ConsumerWidget {
  const _PrescriptionProductQuantitySheetContent({required this.product});

  final ProductModel product;

  void _confirm(BuildContext context, WidgetRef ref) {
    final quantity = ref
        .read(prescriptionNotifierProvider.notifier)
        .parsedProductQuantity();
    final notifier = ref.read(prescriptionNotifierProvider.notifier);
    notifier.addOrUpdateSelectedProduct(
      selectedProduct: PrescriptionSelectedProductModel(
        product: product,
        quantity: quantity,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final notifier = ref.read(prescriptionNotifierProvider.notifier);
    final imageSize = 56.r;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(imageSize / 2),
              child: CommonCachedNetworkImage(
                imageUrl: product.imageUrl,
                width: imageSize,
                height: imageSize,
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: FontPalette.base700(15, color: colors.primaryText),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (product.packSize.isNotEmpty) ...[
                    4.verticalSpace,
                    Text(
                      product.packSize,
                      style: FontPalette.base400(
                        12,
                        color: colors.secondaryText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        20.verticalSpace,
        CommonTextFormField(
          controller: notifier.productQuantityController,
          title: Strings.requestedProductQuantity,
          hintText: Strings.defaultQuantityHint,
          inputType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          borderRadius: 12,
        ),
        24.verticalSpace,
        PrimaryButton(
          text: Strings.addToOrder,
          onPressed: () => _confirm(context, ref),
        ),
      ],
    );
  }
}

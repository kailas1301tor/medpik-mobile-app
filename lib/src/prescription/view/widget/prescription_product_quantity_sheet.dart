// lib/src/prescription/view/widget/prescription_product_quantity_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/data/models/prescription_selected_product_model.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/prescription/notifier/prescription_notifier.dart';
import 'package:tsuite/utils/common_widgets/common_bottom_sheet.dart';
import 'package:tsuite/utils/common_widgets/common_cached_network_image.dart';
import 'package:tsuite/utils/common_widgets/common_text_form_field.dart';
import 'package:tsuite/utils/common_widgets/primary_button.dart';

class PrescriptionProductQuantitySheet {
  PrescriptionProductQuantitySheet._();

  static Future<void> show(
    BuildContext context,
    WidgetRef ref, {
    required ProductModel product,
  }) {
    return CommonBottomSheet.show(
      context: context,
      title: Strings.selectQuantity,
      child: _PrescriptionProductQuantitySheetContent(product: product),
    );
  }
}

class _PrescriptionProductQuantitySheetContent extends ConsumerStatefulWidget {
  const _PrescriptionProductQuantitySheetContent({required this.product});

  final ProductModel product;

  @override
  ConsumerState<_PrescriptionProductQuantitySheetContent> createState() =>
      _PrescriptionProductQuantitySheetContentState();
}

class _PrescriptionProductQuantitySheetContentState
    extends ConsumerState<_PrescriptionProductQuantitySheetContent> {
  late final TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    final currentQty = _currentCartQuantity();
    _quantityController = TextEditingController(
      text: '${currentQty < 1 ? 1 : currentQty}',
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  int _currentCartQuantity() {
    return ref
        .read(prescriptionNotifierProvider.notifier)
        .selectedProductQuantity(widget.product.id);
  }

  int _parsedQuantity() {
    final parsed = int.tryParse(_quantityController.text.trim());
    if (parsed == null || parsed < 1) return 1;
    return parsed;
  }

  void _confirm() {
    final quantity = _parsedQuantity();
    final notifier = ref.read(prescriptionNotifierProvider.notifier);
    final product = widget.product;
    notifier.addOrUpdateSelectedProduct(
      selectedProduct: PrescriptionSelectedProductModel(
        product: product,
        quantity: quantity,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final product = widget.product;
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
                memCacheWidth: 120,
                memCacheHeight: 120,
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
          controller: _quantityController,
          title: Strings.requestedProductQuantity,
          hintText: '1',
          inputType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          borderRadius: 12,
        ),
        24.verticalSpace,
        PrimaryButton(text: Strings.addToOrder, onPressed: _confirm),
      ],
    );
  }
}

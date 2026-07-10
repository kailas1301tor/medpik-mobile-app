// lib/src/prescription/view/widget/prescription_add_missing_product_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/prescription/notifier/prescription_notifier.dart';
import 'package:tsuite/src/prescription/notifier/prescription_products_notifier.dart';
import 'package:tsuite/utils/common_widgets/common_text_form_field.dart';
import 'package:tsuite/utils/common_widgets/custom_toast.dart';
import 'package:tsuite/utils/common_widgets/primary_button.dart';

class PrescriptionAddMissingProductCard extends ConsumerWidget {
  const PrescriptionAddMissingProductCard({super.key, required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final productsNotifier =
        ref.read(prescriptionProductsNotifierProvider.notifier);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: ColorPalette.prescriptionUploadAreaBg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: ColorPalette.prescriptionUploadDashedBorder,
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 18.r,
                color: ColorPalette.prescriptionIconTeal,
              ),
              8.horizontalSpace,
              Expanded(
                child: Text(
                  Strings.productNotFoundInCatalog(query),
                  style: FontPalette.base600(14, color: colors.primaryText),
                ),
              ),
            ],
          ),
          14.verticalSpace,
          CommonTextFormField(
            controller: productsNotifier.missingProductNameController,
            title: Strings.requestedProductName,
            hintText: Strings.requestedProductName,
            borderRadius: 12,
          ),
          12.verticalSpace,
          CommonTextFormField(
            controller: productsNotifier.missingProductQuantityController,
            title: Strings.requestedProductQuantity,
            hintText: '1',
            inputType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            borderRadius: 12,
          ),
          16.verticalSpace,
          PrimaryButton(
            text: Strings.addToPrescriptionRequest,
            onPressed: () => _onAdd(ref, productsNotifier),
          ),
        ],
      ),
    );
  }

  void _onAdd(
    WidgetRef ref,
    PrescriptionProductsNotifier productsNotifier,
  ) {
    final prescriptionNotifier = ref.read(prescriptionNotifierProvider.notifier);
    final quantity = productsNotifier.parsedMissingProductQuantity();
    final name = productsNotifier.missingProductNameController.text.trim();

    if (name.isEmpty) return;

    prescriptionNotifier.appendMissingProductToDescription(
      name: name,
      quantity: quantity,
    );
    productsNotifier.clearSearch();
    showCustomToast(
      message: Strings.productAddedToDescription,
      isSuccess: true,
    );
  }
}

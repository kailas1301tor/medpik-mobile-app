// lib/src/checkout/view/widget/checkout_pharmacist_instructions_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/checkout/notifier/checkout_notifier.dart';
import 'package:tsuite/utils/common_widgets/common_text_form_field.dart';

/// Inline pharmacist instructions on checkout (no bottom sheet).
class CheckoutPharmacistInstructionsCard extends ConsumerWidget {
  const CheckoutPharmacistInstructionsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final notifier = ref.read(checkoutNotifierProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.addInstructionsForPharmacist,
          style: FontPalette.base700(16, color: colors.primaryText),
        ),
        10.verticalSpace,
        CommonTextFormField(
          controller: notifier.pharmacistInstructionsController,
          hintText: Strings.pharmacistInstructionsHint,
          maxLines: 3,
          minLines: 3,
          borderRadius: 14,
          onChanged: notifier.savePharmacistInstructions,
        ),
      ],
    );
  }
}

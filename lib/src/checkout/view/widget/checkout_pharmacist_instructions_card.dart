// lib/src/checkout/view/widget/checkout_pharmacist_instructions_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/src/checkout/notifier/checkout_notifier.dart';
import 'package:medpik/src/checkout/view/widget/checkout_section_card.dart';
import 'package:medpik/utils/common_widgets/common_text_form_field.dart';

/// Inline pharmacist instructions on checkout (no bottom sheet).
class CheckoutPharmacistInstructionsCard extends ConsumerWidget {
  const CheckoutPharmacistInstructionsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final notifier = ref.read(checkoutNotifierProvider.notifier);

    return CheckoutSectionCard(
      title: Strings.addInstructionsForPharmacist,
      titleIcon: Icons.local_pharmacy_outlined,
      child: CommonTextFormField(
        controller: notifier.pharmacistInstructionsController,
        hintText: Strings.pharmacistInstructionsHint,
        maxLines: 3,
        minLines: 3,
        borderRadius: 16,
        filledColor: colors.inputBackground.withValues(alpha: 0.72),
        showBorder: false,
        onChanged: notifier.savePharmacistInstructions,
      ),
    );
  }
}

// lib/src/cart/view/widget/cart_pharmacist_instructions_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/cart/notifier/cart_notifier.dart';
import 'package:tsuite/utils/common_widgets/common_bottom_sheet.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';
import 'package:tsuite/utils/common_widgets/common_text_form_field.dart';
import 'package:tsuite/utils/common_widgets/primary_button.dart';

class CartPharmacistInstructionsCard extends ConsumerWidget {
  const CartPharmacistInstructionsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final instructions = ref.watch(
      cartNotifierProvider.select((s) => s.pharmacistInstructions),
    );

    return CommonContainer(
      padding: EdgeInsets.all(16.r),
      borderRadius: 16.r,
      color: colors.surface,
      onTap: () => _showInstructionsSheet(context, ref),
      child: Row(
        children: [
          Icon(
            Icons.edit_note_rounded,
            size: 22.r,
            color: colors.primary,
          ),
          12.horizontalSpace,
          Expanded(
            child: Text(
              instructions.isEmpty
                  ? Strings.addInstructionsForPharmacist
                  : instructions,
              style: instructions.isEmpty
                  ? FontPalette.base500(14, color: colors.primary)
                  : FontPalette.base400(14, color: colors.primaryText),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: 20.r,
            color: colors.secondaryText,
          ),
        ],
      ),
    );
  }

  Future<void> _showInstructionsSheet(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(cartNotifierProvider.notifier);
    final controller = TextEditingController(
      text: notifier.pharmacistInstructionsController.text,
    );

    await CommonBottomSheet.show(
      context: context,
      title: Strings.addInstructionsForPharmacist,
      isScrollControlled: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonTextFormField(
            controller: controller,
            hintText: Strings.pharmacistInstructionsHint,
            maxLines: 4,
            minLines: 4,
            borderRadius: 20,
          ),
          20.verticalSpace,
          PrimaryButton(
            text: Strings.save,
            radius: 20,
            onPressed: () {
              notifier.savePharmacistInstructions(controller.text);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );

    controller.dispose();
  }
}

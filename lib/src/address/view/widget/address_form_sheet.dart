// lib/src/address/view/widget/address_form_sheet.dart
//
// * Bottom sheet for add/edit address details after map picking.
//
// ? Sections:
// ? 1. [AddressFormMapPickRow] — picked location; can re-open map picker
// ? 2. [AddressFormFields] — label, phone, address lines, default toggle
// ? 3. Save CTA → [AddressNotifier.saveCurrent]
//
// ! Use [AddressFormSheet.show] — never call CommonBottomSheet from features.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/src/address/notifier/address_notifier.dart';
import 'package:medpik/src/address/view/widget/address_form_fields.dart';
import 'package:medpik/src/address/view/widget/address_form_map_pick_row.dart';
import 'package:medpik/utils/common_widgets/common_bottom_sheet.dart';
import 'package:medpik/utils/common_widgets/primary_button.dart';
import 'package:tuple/tuple.dart';

class AddressFormSheet extends ConsumerWidget {
  const AddressFormSheet({super.key});

  static Future<void> show({required BuildContext context, String? title}) {
    return CommonBottomSheet.show(
      context: context,
      title: title ?? Strings.completeAddressDetails,
      isScrollControlled: true,
      child: const AddressFormSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(addressNotifierProvider.notifier);
    final formData = ref.watch(
      addressNotifierProvider.select(
        (s) => Tuple3(s.isSaving, s.isDefaultSelected, s.addresses.isEmpty),
      ),
    );
    final isSaving = formData.item1;
    final isDefaultSelected = formData.item2;
    final forceDefault = formData.item3;

    return IgnorePointer(
      ignoring: isSaving,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AddressFormMapPickRow(notifier: notifier),
          12.verticalSpace,
          AddressFormFields(
            notifier: notifier,
            isDefaultSelected: isDefaultSelected,
            forceDefault: forceDefault,
          ),
          20.verticalSpace,
          PrimaryButton(
            text: Strings.save,
            isLoading: isSaving,
            onPressed: () async {
              final saved = await notifier.saveCurrent();
              if (saved) {
                if (context.mounted) {
                  Navigator.pop(context);
                }
                notifier.resetSaving();
              }
            },
          ),
        ],
      ),
    );
  }
}

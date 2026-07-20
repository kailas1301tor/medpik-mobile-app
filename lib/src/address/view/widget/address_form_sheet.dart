// lib/src/address/view/widget/address_form_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/address/notifier/address_notifier.dart';
import 'package:tsuite/utils/common_widgets/common_bottom_sheet.dart';
import 'package:tsuite/utils/common_widgets/common_text_form_field.dart';
import 'package:tsuite/utils/common_widgets/primary_button.dart';
import 'package:tuple/tuple.dart';

class AddressFormSheet extends ConsumerWidget {
  const AddressFormSheet({super.key});

  static Future<void> show({
    required BuildContext context,
    String? title,
  }) {
    return CommonBottomSheet.show(
      context: context,
      title: title ?? Strings.completeAddressDetails,
      isScrollControlled: true,
      child: const AddressFormSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final notifier = ref.read(addressNotifierProvider.notifier);
    final formData = ref.watch(
      addressNotifierProvider.select(
        (s) => Tuple3(
          s.saveLoaderState,
          s.isDefaultSelected,
          s.addresses.isEmpty,
        ),
      ),
    );
    final saveLoaderState = formData.item1;
    final isDefaultSelected = formData.item2;
    final forceDefault = formData.item3;
    final isSaving = saveLoaderState == LoaderState.loading;

    return IgnorePointer(
      ignoring: isSaving,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CommonTextFormField(
            controller: notifier.labelController,
            hintText: Strings.addressLabel,
          ),
          12.verticalSpace,
          CommonTextFormField(
            controller: notifier.phoneController,
            hintText: Strings.phoneNumber,
            inputType: TextInputType.phone,
          ),
          12.verticalSpace,
          CommonTextFormField(
            controller: notifier.line1Controller,
            hintText: Strings.addressLine1,
          ),
          12.verticalSpace,
          CommonTextFormField(
            controller: notifier.line2Controller,
            hintText: Strings.addressLine2,
          ),
          12.verticalSpace,
          CommonTextFormField(
            controller: notifier.cityController,
            hintText: Strings.city,
          ),
          12.verticalSpace,
          CommonTextFormField(
            controller: notifier.stateController,
            hintText: Strings.stateLabel,
          ),
          12.verticalSpace,
          CommonTextFormField(
            controller: notifier.pincodeController,
            hintText: Strings.pincode,
            inputType: TextInputType.number,
          ),
          8.verticalSpace,
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              Strings.setAsDefault,
              style: FontPalette.base500(14, color: colors.primaryText),
            ),
            value: forceDefault ? true : isDefaultSelected,
            onChanged: forceDefault
                ? null
                : notifier.setDefaultSelection,
          ),
          20.verticalSpace,
          PrimaryButton(
            text: Strings.save,
            isLoading: isSaving,
            onPressed: () async {
              final saved = await notifier.saveCurrent();
              if (saved && context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}

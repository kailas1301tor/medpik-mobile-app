// lib/src/address/view/widget/address_form_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/src/address/notifier/address_notifier.dart';
import 'package:tsuite/utils/common_widgets/common_bottom_sheet.dart';
import 'package:tsuite/utils/common_widgets/common_text_form_field.dart';
import 'package:tsuite/utils/common_widgets/primary_button.dart';

class AddressFormSheet extends ConsumerWidget {
  const AddressFormSheet({super.key});

  static Future<void> show({
    required BuildContext context,
    String? title,
  }) {
    return CommonBottomSheet.show(
      context: context,
      title: title ?? Strings.completeAddressDetails,
      child: const AddressFormSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(addressNotifierProvider.notifier);

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonTextFormField(
            controller: notifier.labelController,
            hintText: Strings.addressLabel,
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
          20.verticalSpace,
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              text: Strings.save,
              onPressed: () async {
                final saved = await notifier.saveCurrent();
                if (saved && context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

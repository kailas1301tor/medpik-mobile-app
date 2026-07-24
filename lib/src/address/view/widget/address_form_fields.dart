// lib/src/address/view/widget/address_form_fields.dart
//
// ? Text inputs for the address form.
//
// ! Controllers are owned by [AddressNotifier] (not local State) so values
// ! survive sheet dismiss/reopen during the same session.
//
// ? [forceDefault] — when user has no saved addresses, default toggle is
// ? locked on (first address must be default).
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/address/notifier/address_notifier.dart';
import 'package:medpik/utils/common_widgets/common_text_form_field.dart';

class AddressFormFields extends StatelessWidget {
  const AddressFormFields({
    super.key,
    required this.notifier,
    required this.isDefaultSelected,
    required this.forceDefault,
  });

  final AddressNotifier notifier;
  final bool isDefaultSelected;
  final bool forceDefault;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
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
          onChanged: forceDefault ? null : notifier.setDefaultSelection,
        ),
      ],
    );
  }
}

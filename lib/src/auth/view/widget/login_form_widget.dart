// lib/src/auth/view/widget/login_form_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tuple/tuple.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/utils/common_widgets/common_field_section.dart';
import 'package:medpik/utils/common_widgets/common_text_form_field.dart';
import 'package:medpik/utils/common_widgets/primary_button.dart';
import '../../notifier/auth_notifier.dart';
import 'login_country_code_field.dart';

class LoginFormWidget extends ConsumerWidget {
  const LoginFormWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(authNotifierProvider.notifier);
    final colors = context.appColors;
    final formState = ref.watch(
      authNotifierProvider.select(
        (s) => Tuple3(s.isRequestingOtp, s.isPhoneValid, s.phoneErrorText),
      ),
    );
    final isRequesting = formState.item1;
    final isPhoneValid = formState.item2;
    final phoneErrorText = formState.item3;
    final fieldHeight = 50.h;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CommonFieldSection(
          title: Strings.mobileNumber,
          errorText: phoneErrorText,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LoginCountryCodeField(height: fieldHeight),
              8.horizontalSpace,
              Expanded(
                child: CommonTextFormField(
                  height: fieldHeight,
                  controller: notifier.phoneController,
                  hintText: Strings.enterYourMobileNumber,
                  inputType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  showErrorText: false,
                  filledColor: colors.surface,
                  borderRadius: 100.r,
                ),
              ),
            ],
          ),
        ),
        32.verticalSpace,
        PrimaryButton(
          text: Strings.getOtp,
          isLoading: isRequesting,
          onPressed: isRequesting || !isPhoneValid
              ? null
              : () {
                  notifier.requestOtp(context);
                },
        ),
      ],
    );
  }
}

// lib/src/auth/view/widget/login_form_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/utils/common_widgets/common_field_section.dart';
import 'package:tsuite/utils/common_widgets/common_text_form_field.dart';
import 'package:tsuite/utils/common_widgets/primary_button.dart';
import 'package:tsuite/utils/routes/route_constants.dart';
import '../../notifier/auth_notifier.dart';
import 'login_country_code_field.dart';

class LoginFormWidget extends ConsumerWidget {
  const LoginFormWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(authNotifierProvider.notifier);
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Consumer(
          builder: (context, ref, _) {
            final phoneErrorText = ref.watch(
              authNotifierProvider.select((s) => s.phoneErrorText),
            );
            final fieldHeight = 50.h;

            return CommonFieldSection(
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
                      borderRadius: 100,
                      onChanged: (_) {
                        if (phoneErrorText != null) {
                          notifier.clearPhoneError();
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        32.verticalSpace,
        Consumer(
          builder: (context, ref, _) {
            final isPhoneValid = ref.watch(
              authNotifierProvider.select((s) => s.isPhoneValid),
            );
            final isLoading = ref.watch(
              authNotifierProvider.select(
                (s) => s.loaderState == LoaderState.loading,
              ),
            );
            return PrimaryButton(
              text: Strings.getOtp,
              isLoading: isLoading,
              onPressed: isPhoneValid && !isLoading
                  ? () async {
                      final success = await notifier.requestOtp();
                      if (success && context.mounted) {
                        Navigator.pushNamed(
                          context,
                          RouteConstants.routeOtpScreen,
                        );
                      }
                    }
                  : null,
            );
          },
        ),
      ],
    );
  }
}

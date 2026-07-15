// lib/src/auth/view/otp_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/utils/common_widgets/common_app_bar.dart';
import 'package:tsuite/utils/common_widgets/common_loader.dart';
import 'package:tsuite/utils/common_widgets/common_otp_field.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';
import 'package:tsuite/utils/routes/route_constants.dart';
import '../notifier/auth_notifier.dart';

class OtpScreen extends ConsumerWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final notifier = ref.read(authNotifierProvider.notifier);
    final phone = notifier.phoneController.text;

    return CommonScaffold(
      appBar: const CommonAppBar(title: Strings.verification),
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              50.verticalSpace,
              Text(
                Strings.enterVerificationCode,
                style: FontPalette.base700(24, color: colors.primaryText),
              ),
              12.verticalSpace,
              RichText(
                text: TextSpan(
                  style: FontPalette.base400(15, color: colors.secondaryText),
                  children: [
                    TextSpan(text: Strings.otpSentPrefix),
                    TextSpan(
                      text: '${Strings.countryCodeIndia} $phone',
                      style: FontPalette.base500(14, color: colors.primaryText),
                    ),
                  ],
                ),
              ),
              30.verticalSpace,
              Consumer(
                builder: (context, ref, _) {
                  final isLoading = ref.watch(
                    authNotifierProvider.select(
                      (s) => s.loaderState == LoaderState.loading,
                    ),
                  );
                  return Column(
                    children: [
                      CommonOtpField(
                        length: 6,
                        onCompleted: isLoading
                            ? null
                            : (pin) async {
                                final success =
                                    await notifier.verifyOtpCode(pin);
                                if (success && context.mounted) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    RouteConstants.mainScreen,
                                    (route) => false,
                                  );
                                }
                              },
                      ),
                      if (isLoading) ...[
                        24.verticalSpace,
                        const CommonLoader(),
                      ],
                    ],
                  );
                },
              ),
              40.verticalSpace,
              Consumer(
                builder: (context, ref, _) {
                  final countdown = ref.watch(
                    authNotifierProvider.select((s) => s.resendCountdown),
                  );
                  final isLoading = ref.watch(
                    authNotifierProvider.select(
                      (s) => s.loaderState == LoaderState.loading,
                    ),
                  );

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Strings.didntReceiveCode,
                        style: FontPalette.base400(
                          14,
                          color: colors.secondaryText,
                        ),
                      ),
                      TextButton(
                        onPressed: countdown == 0 && !isLoading
                            ? () => notifier.resendOtp()
                            : null,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          countdown == 0
                              ? Strings.resendCode
                              : '${Strings.resendIn} ${countdown}s',
                          style: FontPalette.base600(
                            14,
                            color: countdown == 0
                                ? colors.primary
                                : colors.secondaryText,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

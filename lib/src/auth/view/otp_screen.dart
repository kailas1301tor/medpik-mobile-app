// lib/src/auth/view/otp_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/src/auth/notifier/auth_notifier.dart';
import 'package:medpik/utils/common_widgets/common_app_bar.dart';
import 'package:medpik/utils/common_widgets/common_scaffold.dart';
import 'package:medpik/utils/routes/route_constants.dart';
import 'widget/otp_input_section.dart';
import 'widget/otp_phone_header.dart';
import 'widget/otp_resend_row.dart';
import 'widget/otp_verify_button.dart';

class OtpScreen extends ConsumerWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final otpPhone = ref.watch(authNotifierProvider.select((s) => s.otpPhone));

    if (otpPhone == null || otpPhone.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        Navigator.pushReplacementNamed(
          context,
          RouteConstants.routeLoginScreen,
        );
      });
    }

    return CommonScaffold(
      appBar: const CommonAppBar(title: Strings.verification),
      backgroundColor: colors.background,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const OtpPhoneHeader(),
            30.verticalSpace,
            const OtpInputSection(),
            32.verticalSpace,
            const OtpVerifyButton(),
            40.verticalSpace,
            const OtpResendRow(),
          ],
        ),
      ),
    );
  }
}

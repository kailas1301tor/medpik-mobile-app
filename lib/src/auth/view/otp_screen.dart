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

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _redirectIfNoSession());
  }

  void _redirectIfNoSession() {
    if (!mounted) return;
    final phone = ref.read(authNotifierProvider).otpPhone;
    if (phone != null && phone.isNotEmpty) return;
    Navigator.pushReplacementNamed(context, RouteConstants.routeLoginScreen);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    ref.listen(
      authNotifierProvider.select((s) => s.otpPhone),
      (previous, next) {
        if (next != null && next.isNotEmpty) return;
        if (!context.mounted) return;
        Navigator.pushReplacementNamed(
          context,
          RouteConstants.routeLoginScreen,
        );
      },
    );

    return CommonScaffold(
      appBar: const CommonAppBar(title: Strings.verification),
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
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
      ),
    );
  }
}

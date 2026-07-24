// lib/src/auth/view/widget/otp_input_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/app_constants.dart';
import 'package:medpik/utils/common_widgets/common_otp_field.dart';
import '../../notifier/auth_notifier.dart';
import 'otp_error_message_row.dart';

class OtpInputSection extends ConsumerWidget {
  const OtpInputSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(authNotifierProvider.notifier);
    final otpErrorMessage = ref.watch(
      authNotifierProvider.select((s) => s.otpErrorMessage),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CommonOtpField(
          controller: notifier.otpController,
          length: AppConstants.otpLength,
          hasError: otpErrorMessage != null,
          onCompleted: (_) {
            if (!context.mounted) return;
            notifier.onOtpCompleted(context);
          },
        ),
        if (otpErrorMessage != null) ...[
          8.verticalSpace,
          OtpErrorMessageRow(message: otpErrorMessage),
        ],
      ],
    );
  }
}

// lib/src/auth/view/widget/otp_verify_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/utils/common_widgets/primary_button.dart';
import '../../notifier/auth_notifier.dart';

class OtpVerifyButton extends ConsumerWidget {
  const OtpVerifyButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(authNotifierProvider.notifier);
    final formState = ref.watch(
      authNotifierProvider.select(
        (s) => Tuple4(
          s.isVerifyingOtp,
          s.isOtpValid,
          s.isResendingOtp,
          s.isRequestingOtp,
        ),
      ),
    );
    final isVerifying = formState.item1;
    final isOtpValid = formState.item2;
    final isResendingOtp = formState.item3;
    final isRequestingOtp = formState.item4;

    return PrimaryButton(
      text: Strings.verifyOtp,
      isLoading: isVerifying,
    
      onPressed: isVerifying || isResendingOtp || isRequestingOtp || !isOtpValid
          ? null
          : () => notifier.verifyOtp(context),
    );
  }
}

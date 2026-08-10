// lib/src/auth/view/widget/otp_resend_row.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/utils/common_widgets/common_text_button.dart';
import 'package:tuple/tuple.dart';
import '../../notifier/auth_notifier.dart';

class OtpResendRow extends ConsumerWidget {
  const OtpResendRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final actionState = ref.watch(
      authNotifierProvider.select(
        (s) => Tuple2(s.resendCountdown, s.isResendingOtp),
      ),
    );
    final countdown = actionState.item1;
    final isResendingOtp = actionState.item2;

    final label = isResendingOtp
        ? Strings.resendingCode
        : countdown == 0
            ? Strings.resendCode
            : '${Strings.resendIn} ${countdown}s';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          Strings.didntReceiveCode,
          style: FontPalette.base400(14, color: colors.secondaryText),
        ),
        CommonTextButton(
          label: label,
          onPressed: countdown == 0 && !isResendingOtp
              ? () => ref.read(authNotifierProvider.notifier).resendOtp()
              : null,
          style: FontPalette.base600(
            14,
            color: countdown == 0 && !isResendingOtp
                ? colors.primary
                : colors.secondaryText,
          ),
        ),
      ],
    );
  }
}

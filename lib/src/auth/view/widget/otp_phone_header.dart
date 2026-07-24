// lib/src/auth/view/widget/otp_phone_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import '../../notifier/auth_notifier.dart';

class OtpPhoneHeader extends ConsumerWidget {
  const OtpPhoneHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final phone = ref.watch(
      authNotifierProvider.select((s) => s.otpPhone),
    );

    if (phone == null || phone.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
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
      ],
    );
  }
}

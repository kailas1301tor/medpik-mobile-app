// lib/src/auth/view/widget/otp_error_message_row.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';

class OtpErrorMessageRow extends StatelessWidget {
  const OtpErrorMessageRow({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.info_outline_rounded,
          size: 16.r,
          color: colors.errorText,
        ),
        6.horizontalSpace,
        Expanded(
          child: Text(
            message,
            style: FontPalette.base400(13, color: colors.errorText),
          ),
        ),
      ],
    );
  }
}

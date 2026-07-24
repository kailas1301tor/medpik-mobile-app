// /Users/wac/Documents/tortilon/medpik/lib/utils/common_widgets/common_otp_field.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';

class CommonOtpField extends StatelessWidget {
  const CommonOtpField({
    super.key,
    this.controller,
    this.length = 4,
    this.onChanged,
    this.onCompleted,
    this.hasError = false,
  });

  final TextEditingController? controller;
  final int length;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final separatorWidth = 8.w;
        final pinSize =
            ((constraints.maxWidth - (separatorWidth * (length - 1))) / length)
                .clamp(44.r, 52.r);
        final borderRadius = BorderRadius.circular(pinSize / 2);

        final pinTheme = PinTheme(
          width: pinSize,
          height: pinSize,
          constraints: BoxConstraints.tightFor(width: pinSize, height: pinSize),
          textStyle: FontPalette.base600(18, color: colors.primaryText),
          decoration: BoxDecoration(
            color: colors.inputBackground,
            borderRadius: borderRadius,
            border: Border.all(
              color: hasError ? colors.errorText : colors.inputBorder,
            ),
          ),
        );

        return Pinput(
          controller: controller,
          length: length,
          defaultPinTheme: pinTheme,
          focusedPinTheme: pinTheme.copyDecorationWith(
            border: Border.all(
              color: hasError ? colors.errorText : colors.accent,
            ),
            borderRadius: borderRadius,
          ),
          errorPinTheme: pinTheme,
          onChanged: onChanged,
          onCompleted: onCompleted,
          separatorBuilder: (_) => SizedBox(width: separatorWidth),
          mainAxisAlignment: MainAxisAlignment.center,
        );
      },
    );
  }
}

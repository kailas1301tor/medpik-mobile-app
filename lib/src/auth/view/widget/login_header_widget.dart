// lib/src/auth/view/widget/login_header_widget.dart
import 'package:flutter/material.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          Strings.letsGetStarted,
          textAlign: TextAlign.center,
          style: FontPalette.base700(32, color: colors.primaryText),
        ),
      ],
    );
  }
}

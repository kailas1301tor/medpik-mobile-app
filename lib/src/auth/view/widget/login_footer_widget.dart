// lib/src/auth/view/widget/login_footer_widget.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/utils/routes/route_constants.dart';

class LoginFooterWidget extends StatefulWidget {
  const LoginFooterWidget({super.key});

  @override
  State<LoginFooterWidget> createState() => _LoginFooterWidgetState();
}

class _LoginFooterWidgetState extends State<LoginFooterWidget> {
  late final TapGestureRecognizer _signUpRecognizer;

  @override
  void initState() {
    super.initState();
    _signUpRecognizer = TapGestureRecognizer()..onTap = _onSignUpTap;
  }

  @override
  void dispose() {
    _signUpRecognizer.dispose();
    super.dispose();
  }

  void _onSignUpTap() {
    Navigator.pushNamed(context, RouteConstants.routeRegisterScreen);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Text.rich(
      TextSpan(
        text: Strings.dontHaveAccount,
        style: FontPalette.base400(14, color: colors.secondaryText),
        children: [
          TextSpan(
            text: Strings.signUp,
            style: FontPalette.base700(14, color: colors.primary),
            recognizer: _signUpRecognizer,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

// /Users/wac/Documents/wac projects/tsuite/lib/utils/common_widgets/common_password_field.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tsuite/res/constants/assets.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/utils/common_widgets/common_text_form_field.dart';

class CommonPasswordField extends StatefulWidget {
  const CommonPasswordField({
    super.key,
    required this.controller,
    this.hintText,
    this.errorText,
    this.focusNode,
    this.onChanged,
    this.filledColor,
    this.borderRadius,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? errorText;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final Color? filledColor;
  final double? borderRadius;

  @override
  State<CommonPasswordField> createState() => _CommonPasswordFieldState();
}

class _CommonPasswordFieldState extends State<CommonPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return CommonTextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      hintText: widget.hintText ?? '',
      errorText: widget.errorText,
      isObscure: _obscureText,
      onChanged: widget.onChanged,
      filledColor: widget.filledColor,
      borderRadius: widget.borderRadius,
      suffix: IconButton(
        tooltip: _obscureText ? Strings.showPassword : Strings.hidePassword,
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        icon: SvgPicture.asset(
          _obscureText ? Assets.svgEyeHidden : Assets.svgEyeVisible,
          width: 20.r,
          height: 20.r,
          colorFilter: ColorFilter.mode(colors.secondaryText, BlendMode.srcIn),
        ),
      ),
    );
  }
}

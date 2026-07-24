// lib/utils/common_widgets/common_text_button.dart
import 'package:flutter/material.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';

class CommonTextButton extends StatelessWidget {
  const CommonTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style,
    this.padding,
  });

  final String label;
  final VoidCallback? onPressed;
  final TextStyle? style;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isEnabled = onPressed != null;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: padding ?? EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        style: style ??
            FontPalette.base600(
              14,
              color: isEnabled ? colors.primary : colors.secondaryText,
            ),
      ),
    );
  }
}

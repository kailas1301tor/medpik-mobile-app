// /Users/wac/Documents/tortilon/medpik/lib/utils/common_widgets/common_field_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';

class CommonFieldSection extends StatelessWidget {
  const CommonFieldSection({
    super.key,
    required this.title,
    required this.child,
    this.helperText,
    this.errorText,
    this.trailing,
  });

  final String title;
  final Widget child;
  final String? helperText;
  final String? errorText;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: FontPalette.base600(14, color: colors.primaryText),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
        if (helperText != null) ...[
          4.verticalSpace,
          Text(
            helperText!,
            style: FontPalette.base400(12, color: colors.secondaryText),
          ),
        ],
        8.verticalSpace,
        child,
        if (errorText != null) ...[
          6.verticalSpace,
          Text(
            errorText!,
            style: FontPalette.base400(
              12,
              color: ColorPalette.formValidationErrorColor,
            ),
          ),
        ],
      ],
    );
  }
}

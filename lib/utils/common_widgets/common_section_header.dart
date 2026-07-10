// /Users/wac/Documents/wac projects/tsuite/lib/utils/common_widgets/common_section_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';

class CommonSectionHeader extends StatelessWidget {
  const CommonSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onActionTap,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onActionTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: FontPalette.base700(20, color: colors.primaryText),
              ),
              if (subtitle != null) ...[
                6.verticalSpace,
                Text(
                  subtitle!,
                  style: FontPalette.base400(14, color: colors.secondaryText),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null)
          trailing!
        else if (actionText != null)
          TextButton(
            onPressed: onActionTap,
            child: Text(
              actionText ?? Strings.viewAll,
              style: FontPalette.base600(14, color: colors.accent),
            ),
          ),
      ],
    );
  }
}

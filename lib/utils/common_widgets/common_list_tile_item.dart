// /Users/wac/Documents/tortilon/medpik/lib/utils/common_widgets/common_list_tile_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';

class CommonListTileItem extends StatelessWidget {
  const CommonListTileItem({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.showDivider = false,
    this.padding,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final tile = Padding(
      padding:
          padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          if (leading != null) ...[leading!, 12.horizontalSpace],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: FontPalette.base600(15, color: colors.primaryText),
                ),
                if (subtitle != null) ...[
                  4.verticalSpace,
                  Text(
                    subtitle!,
                    style: FontPalette.base400(13, color: colors.secondaryText),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );

    final interactiveTile = Material(
      color: Colors.transparent,
      child: InkWell(onTap: onTap, child: tile),
    );

    return Column(
      children: [
        onTap != null ? interactiveTile : tile,
        if (showDivider)
          Divider(
            height: 1.h,
            thickness: 1.h,
            color: ColorPalette.black.withValues(alpha: 0.06),
          ),
      ],
    );
  }
}

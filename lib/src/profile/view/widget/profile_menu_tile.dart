// lib/src/profile/view/widget/profile_menu_tile.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';

class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({
    super.key,
    this.icon,
    this.iconAsset,
    required this.title,
    this.subtitle,
    this.iconColor,
    this.onTap,
    this.showDivider = true,
  }) : assert(icon != null || iconAsset != null);

  final IconData? icon;
  final String? iconAsset;
  final String title;
  final String? subtitle;
  final Color? iconColor;
  final VoidCallback? onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final effectiveIconColor = iconColor ?? ColorPalette.productAccentTeal;

    return Column(
      children: [
        Material(
          color: colors.surface,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              child: Row(
                children: [
                  Container(
                    width: 36.r,
                    height: 36.r,
                    decoration: BoxDecoration(
                      color: effectiveIconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: iconAsset != null
                        ? SvgPicture.asset(
                            iconAsset!,
                            width: 18.r,
                            height: 18.r,
                          )
                        : Icon(icon, size: 18.r, color: effectiveIconColor),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: FontPalette.base600(
                            14,
                            color: colors.primaryText,
                          ),
                        ),
                        if (subtitle != null) ...[
                          2.verticalSpace,
                          Text(
                            subtitle!,
                            style: FontPalette.base400(
                              11,
                              color: colors.secondaryText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 22.r,
                    color: colors.secondaryText,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1.h,
            thickness: 1,
            indent: 62.w,
            color: colors.inputBorder.withValues(alpha: 0.6),
          ),
      ],
    );
  }
}

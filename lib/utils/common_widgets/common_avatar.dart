// /Users/wac/Documents/wac projects/tsuite/lib/utils/common_widgets/common_avatar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/utils/common_widgets/common_cached_network_image.dart';

class CommonAvatar extends StatelessWidget {
  const CommonAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.size,
    this.borderRadius,
    this.fallbackIcon,
  });

  final String? imageUrl;
  final String? initials;
  final double? size;
  final double? borderRadius;
  final Widget? fallbackIcon;

  @override
  Widget build(BuildContext context) {
    final effectiveSize = size ?? 52.r;
    final effectiveRadius = borderRadius ?? effectiveSize / 2;
    final cleanInitials = initials?.trim();

    final fallback = Container(
      width: effectiveSize,
      height: effectiveSize,
      decoration: BoxDecoration(
        color: context.appColors.inputBackground,
        borderRadius: BorderRadius.circular(effectiveRadius),
      ),
      alignment: Alignment.center,
      child: cleanInitials != null && cleanInitials.isNotEmpty
          ? Text(
              cleanInitials,
              style: FontPalette.base600(
                16,
                color: context.appColors.primaryText,
              ),
            )
          : fallbackIcon ??
                Icon(
                  Icons.person_outline_rounded,
                  size: 22.r,
                  color: ColorPalette.f808080,
                ),
    );

    return CommonCachedNetworkImage(
      imageUrl: imageUrl,
      width: effectiveSize,
      height: effectiveSize,
      borderRadius: effectiveRadius,
      errorWidget: fallback,
      placeholder: fallback,
    );
  }
}

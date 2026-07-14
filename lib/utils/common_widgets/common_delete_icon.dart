// lib/utils/common_widgets/common_delete_icon.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tsuite/res/constants/medpik_svg_assets.dart';
import 'package:tsuite/res/styles/color_palette.dart';

class CommonDeleteIcon extends StatelessWidget {
  const CommonDeleteIcon({
    super.key,
    this.size,
    this.color,
  });

  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final iconSize = size ?? 20.r;
    final iconColor = color ?? ColorPalette.formValidationErrorColor;

    return SvgPicture.asset(
      MedpikSvgAssets.trash,
      width: iconSize,
      height: iconSize,
      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
    );
  }
}

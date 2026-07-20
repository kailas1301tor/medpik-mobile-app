// lib/utils/common_widgets/common_delete_icon.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final iconSize = size ?? 22.r;
    final iconColor = color ?? ColorPalette.formValidationErrorColor;

    return Icon(
      CupertinoIcons.minus_circle_fill,
      size: iconSize,
      color: iconColor,
    );
  }
}

// /Users/wac/Documents/wac projects/tsuite/lib/utils/common_widgets/common_inline_loader.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/styles/color_palette.dart';

class CommonInlineLoader extends StatelessWidget {
  const CommonInlineLoader({
    super.key,
    this.size,
    this.strokeWidth = 2.2,
    this.color,
  });

  final double? size;
  final double strokeWidth;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveSize = size ?? 18.r;

    return SizedBox.square(
      dimension: effectiveSize,
      child: CircularProgressIndicator.adaptive(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? context.appColors.accent,
        ),
      ),
    );
  }
}

// /Users/wac/Documents/tortilon/medpik/lib/utils/common_widgets/common_shimmer_box.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:medpik/res/styles/color_palette.dart';

class CommonShimmerBox extends StatelessWidget {
  const CommonShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
    this.color,
  });

  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;
  /// Fill color of the shimmer bar (defaults to theme input background).
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final fill = color ?? context.appColors.inputBackground;
    return Shimmer.fromColors(
      baseColor: baseColor ?? fill,
      highlightColor: highlightColor ?? context.appColors.shimmerHighlight,
      child: Container(
        width: width,
        height: height ?? 16.h,
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular((borderRadius ?? 12).r),
        ),
      ),
    );
  }
}

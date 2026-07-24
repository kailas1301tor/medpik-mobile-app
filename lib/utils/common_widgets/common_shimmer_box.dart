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
  });

  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? context.appColors.inputBackground,
      highlightColor: highlightColor ?? context.appColors.shimmerHighlight,
      child: Container(
        width: width,
        height: height ?? 16.h,
        decoration: BoxDecoration(
          color: context.appColors.inputBackground,
          borderRadius: BorderRadius.circular((borderRadius ?? 12).r),
        ),
      ),
    );
  }
}

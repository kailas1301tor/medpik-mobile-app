// /Users/wac/Documents/wac projects/tsuite/lib/utils/common_widgets/common_container.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:tsuite/res/styles/color_palette.dart';

class CommonContainer extends StatelessWidget {
  const CommonContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.border,
    this.onTap,
    this.width,
    this.height,
    this.boxShadow,
    this.side,
    this.smoothness,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? borderRadius;
  final BoxBorder? border;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final List<BoxShadow>? boxShadow;
  final BorderSide? side;
  final double? smoothness;

  @override
  Widget build(BuildContext context) {
    final borderRadiusValue = (borderRadius ?? 20).r;
    final shape = SmoothRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadiusValue),
      side: border?.top ?? BorderSide.none,
      smoothness: smoothness ?? 2,
    );

    return SmoothContainer(
      width: width,
      height: height,
      margin: margin,
      smoothness: smoothness ?? 2,
      borderRadius: BorderRadius.circular(borderRadiusValue),
      side:
          side ??
          BorderSide(
            color: context.appColors.cardBorder.withValues(alpha: 0.6),
            width: 1.w,
          ),
      color: color ?? context.appColors.surface,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: shape,
          child: Padding(
            padding: padding ?? EdgeInsets.all(16.r),
            child: child,
          ),
        ),
      ),
    );
  }
}

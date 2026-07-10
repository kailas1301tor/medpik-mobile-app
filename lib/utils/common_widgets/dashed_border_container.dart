// lib/utils/common_widgets/dashed_border_container.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/styles/color_palette.dart';

class DashedBorderContainer extends StatelessWidget {
  const DashedBorderContainer({
    super.key,
    required this.child,
    this.onTap,
    this.height,
    this.width,
    this.borderRadius = 16,
    this.borderColor = ColorPalette.prescriptionUploadDashedBorder,
    this.backgroundColor = ColorPalette.prescriptionUploadAreaBg,
    this.dashWidth = 5,
    this.dashGap = 5,
    this.strokeWidth = 2,
    this.padding,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double? height;
  final double? width;
  final double borderRadius;
  final Color borderColor;
  final Color backgroundColor;
  final double dashWidth;
  final double dashGap;
  final double strokeWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius.r;
    final painter = _DashedBorderPainter(
      color: borderColor,
      strokeWidth: strokeWidth.w,
      dashWidth: dashWidth.w,
      dashGap: dashGap.w,
      borderRadius: radius,
    );

    final content = CustomPaint(
      foregroundPainter: painter,
      child: Container(
        height: height,
        width: width,
        padding: padding ?? EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: child,
      ),
    );

    if (onTap == null) return content;

    return Material(
      color: ColorPalette.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: content,
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashGap,
    required this.borderRadius,
  });

  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashGap;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final halfStroke = strokeWidth / 2;
    final rect = Rect.fromLTWH(
      halfStroke,
      halfStroke,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    final path = Path()..addRRect(rrect);

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        final extractPath = metric.extractPath(
          distance,
          next.clamp(0, metric.length),
        );
        canvas.drawPath(extractPath, paint);
        distance = next + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashGap != dashGap ||
        oldDelegate.borderRadius != borderRadius;
  }
}

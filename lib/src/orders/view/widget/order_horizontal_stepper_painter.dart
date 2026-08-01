// lib/src/orders/view/widget/order_horizontal_stepper_painter.dart
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class OrderStepperTrackPainter extends CustomPainter {
  OrderStepperTrackPainter({
    required this.nodeCenters,
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
    required this.failedSegmentIndex,
    required this.lineY,
    required this.strokeWidth,
  });

  final List<Offset> nodeCenters;
  final double progress;
  final Color activeColor;
  final Color inactiveColor;
  final int? failedSegmentIndex;
  final double lineY;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (nodeCenters.length < 2) return;

    final startX = nodeCenters.first.dx;
    final endX = nodeCenters.last.dx;
    final trackRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(startX, lineY - strokeWidth / 2, endX - startX, strokeWidth),
      Radius.circular(strokeWidth / 2),
    );

    final inactivePaint = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.fill;

    canvas.drawRRect(trackRect, inactivePaint);

    final segmentCount = nodeCenters.length - 1;
    final clampedProgress = progress.clamp(0.0, segmentCount.toDouble());

    for (var i = 0; i < segmentCount; i++) {
      final segmentStart = nodeCenters[i].dx;
      final segmentEnd = nodeCenters[i + 1].dx;
      final segmentWidth = segmentEnd - segmentStart;
      if (segmentWidth <= 0) continue;

      final fillAmount = (clampedProgress - i).clamp(0.0, 1.0);
      if (fillAmount <= 0) continue;

      final fillWidth = segmentWidth * fillAmount;
      final isFailed = failedSegmentIndex == i;
      final fillPaint = Paint()
        ..shader = ui.Gradient.linear(
          Offset(segmentStart, lineY),
          Offset(segmentStart + fillWidth, lineY),
          isFailed
              ? [inactiveColor, inactiveColor]
              : [
                  activeColor.withValues(alpha: 0.85),
                  activeColor,
                ],
        )
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            segmentStart,
            lineY - strokeWidth / 2,
            fillWidth,
            strokeWidth,
          ),
          Radius.circular(strokeWidth / 2),
        ),
        fillPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant OrderStepperTrackPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor ||
        oldDelegate.failedSegmentIndex != failedSegmentIndex ||
        oldDelegate.lineY != lineY ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.nodeCenters.length != nodeCenters.length;
  }
}

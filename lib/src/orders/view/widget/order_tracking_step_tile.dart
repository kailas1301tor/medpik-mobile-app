// lib/src/orders/view/widget/order_tracking_step_tile.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/utils/helpers/order_status_helper.dart';

class OrderTrackingStepTile extends StatelessWidget {
  const OrderTrackingStepTile({
    super.key,
    required this.step,
    required this.isLast,
    required this.isCurrent,
    required this.index,
    required this.primaryColor,
    required this.inputBorderColor,
  });

  final OrderTrackingStep step;
  final bool isLast;
  final bool isCurrent;
  final int index;
  final Color primaryColor;
  final Color inputBorderColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDone = step.isCompleted;
    final isFailed = step.isFailed;
    final dotColor = isFailed
        ? colors.statusErrorText
        : isDone
        ? primaryColor
        : colors.inputBackground;
    final lineColor = isDone
        ? primaryColor.withValues(alpha: 0.62)
        : inputBorderColor.withValues(alpha: 0.32);
    final labelColor = isFailed
        ? colors.statusErrorText
        : isDone
        ? colors.primaryText
        : colors.secondaryText;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 360 + index * 55),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 8.h),
            child: child,
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                width: isCurrent ? 30.r : 26.r,
                height: isCurrent ? 30.r : 26.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dotColor,
                  border: isDone
                      ? null
                      : Border.all(
                          color: inputBorderColor.withValues(alpha: 0.5),
                          width: 1.w,
                        ),
                  boxShadow: isCurrent
                      ? [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.24),
                            blurRadius: 16.r,
                            offset: Offset(0, 6.h),
                          ),
                        ]
                      : null,
                ),
                child: isDone
                    ? Icon(
                        isFailed ? Icons.close : Icons.check,
                        size: isCurrent ? 16.r : 14.r,
                        color: ColorPalette.white,
                      )
                    : Icon(
                        Icons.circle,
                        size: 7.r,
                        color: inputBorderColor.withValues(alpha: 0.65),
                      ),
              ),
              if (!isLast)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  width: 2.w,
                  height: 42.h,
                  decoration: BoxDecoration(
                    color: lineColor,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
            ],
          ),
          12.horizontalSpace,
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24.h),
              child: Text(
                step.label,
                style: FontPalette.base600(
                  isCurrent ? 15 : 14,
                  color: labelColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

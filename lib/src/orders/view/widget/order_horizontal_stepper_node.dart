// lib/src/orders/view/widget/order_horizontal_stepper_node.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/utils/helpers/order_status_helper.dart';

class OrderHorizontalStepperNode extends StatelessWidget {
  const OrderHorizontalStepperNode({
    super.key,
    required this.step,
    required this.primaryColor,
    required this.inactiveColor,
    required this.pulseValue,
  });

  final OrderHorizontalStep step;
  final Color primaryColor;
  final Color inactiveColor;
  final double pulseValue;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isCurrent = step.state == OrderStepperNodeState.current;
    final isFailed = step.state == OrderStepperNodeState.failed;
    final isCompleted = step.state == OrderStepperNodeState.completed;
    final isActive = isCompleted || isCurrent;

    final baseSize = isCurrent ? 34.r : 30.r;
    final scale = 1.0 + (isCurrent ? pulseValue * 0.06 : 0);
    final dotSize = baseSize * scale;

    final dotColor = isFailed
        ? colors.statusErrorText
        : isActive
        ? primaryColor
        : colors.inputBackground;

    final iconColor = isFailed || isActive ? ColorPalette.white : inactiveColor;

    final labelColor = isFailed
        ? colors.statusErrorText
        : isActive
        ? colors.primaryText
        : colors.secondaryText;

    return Column(
      children: [
        SizedBox(
          width: 40.r,
          height: 40.r,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (isCurrent)
                Container(
                  width: dotSize + 10.r + pulseValue * 6.r,
                  height: dotSize + 10.r + pulseValue * 6.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor.withValues(
                      alpha: 0.12 + pulseValue * 0.1,
                    ),
                  ),
                ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                width: dotSize,
                height: dotSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isActive && !isFailed
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            ColorPalette.primaryGradientStart,
                            ColorPalette.primaryColor,
                          ],
                        )
                      : null,
                  color: isActive && !isFailed ? null : dotColor,
                  border: isActive
                      ? null
                      : Border.all(
                          color: inactiveColor.withValues(alpha: 0.5),
                          width: 1.w,
                        ),
                  boxShadow: isCurrent
                      ? [
                          BoxShadow(
                            color: primaryColor.withValues(
                              alpha: 0.22 + pulseValue * 0.12,
                            ),
                            blurRadius: 10.r + pulseValue * 4.r,
                            offset: Offset(0, 3.h),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  step.icon,
                  size: isCurrent ? 16.r : 14.r,
                  color: iconColor,
                ),
              ),
            ],
          ),
        ),
        8.verticalSpace,
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: FontPalette.base500(isCurrent ? 10 : 9, color: labelColor),
          child: Text(
            step.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// lib/src/orders/view/widget/order_horizontal_stepper.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/utils/helpers/order_status_helper.dart';

class OrderHorizontalStepper extends StatelessWidget {
  const OrderHorizontalStepper({super.key, required this.steps});

  final List<OrderHorizontalStep> steps;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          if (i > 0)
            Expanded(
              child: Container(
                height: 2.h,
                margin: EdgeInsets.only(bottom: 18.h),
                color: _connectorColor(steps[i - 1].state, steps[i].state, colors),
              ),
            ),
          _StepNode(step: steps[i], primaryColor: colors.primary),
        ],
      ],
    );
  }

  Color _connectorColor(
    OrderStepperNodeState left,
    OrderStepperNodeState right,
    AppColors colors,
  ) {
    if (left == OrderStepperNodeState.failed) {
      return colors.inputBorder;
    }
    if (left == OrderStepperNodeState.completed ||
        left == OrderStepperNodeState.current) {
      return colors.primary;
    }
    return colors.inputBorder;
  }
}

class _StepNode extends StatelessWidget {
  const _StepNode({required this.step, required this.primaryColor});

  final OrderHorizontalStep step;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isCurrent = step.state == OrderStepperNodeState.current;
    final isFailed = step.state == OrderStepperNodeState.failed;
    final isCompleted = step.state == OrderStepperNodeState.completed;
    final dotSize = isCurrent ? 32.r : 28.r;

    final dotColor = isFailed
        ? colors.statusErrorText
        : isCompleted || isCurrent
        ? primaryColor
        : colors.inputBorder;

    final iconColor = isFailed || isCompleted || isCurrent
        ? ColorPalette.white
        : colors.secondaryText;

    return SizedBox(
      width: 56.w,
      child: Column(
        children: [
          Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dotColor,
              border: isCurrent
                  ? Border.all(color: primaryColor, width: 2.w)
                  : null,
            ),
            child: Icon(step.icon, size: isCurrent ? 16.r : 14.r, color: iconColor),
          ),
          6.verticalSpace,
          Text(
            step.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: FontPalette.base400(
              9,
              color: isFailed
                  ? colors.statusErrorText
                  : isCompleted || isCurrent
                  ? colors.primaryText
                  : colors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

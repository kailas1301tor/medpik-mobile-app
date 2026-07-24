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
    required this.primaryColor,
    required this.inputBorderColor,
  });

  final OrderTrackingStep step;
  final bool isLast;
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
        : inputBorderColor;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24.r,
              height: 24.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dotColor,
              ),
              child: isDone
                  ? Icon(
                      isFailed ? Icons.close : Icons.check,
                      size: 14.r,
                      color: ColorPalette.white,
                    )
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2.w,
                height: 40.h,
                color: isDone ? primaryColor : inputBorderColor,
              ),
          ],
        ),
        12.horizontalSpace,
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 24.h),
            child: Text(
              step.label,
              style: FontPalette.base500(
                14,
                color: isFailed
                    ? colors.statusErrorText
                    : isDone
                    ? colors.primaryText
                    : colors.secondaryText,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

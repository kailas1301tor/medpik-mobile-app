// lib/src/orders/view/widget/order_status_badge.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/utils/helpers/order_status_helper.dart';

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({
    super.key,
    required this.status,
    this.label,
    this.useRecessedStyle = false,
  });

  final OrderStatus status;
  final String? label;
  final bool useRecessedStyle;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final (background, textColor) = orderStatusBadgeColors(status, colors);
    final displayLabel = label ?? orderStatusLabel(status);

    if (useRecessedStyle) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(color: colors.divider.withValues(alpha: 0.7)),
          boxShadow: ColorPalette.orderTileInsetShadow(
            isDark: Theme.of(context).brightness == Brightness.dark,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          child: Text(
            displayLabel.toUpperCase(),
            style: FontPalette.base700(10, color: colors.primary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }

    return SmoothContainer(
      smoothness: 1,
      color: background,
      borderRadius: BorderRadius.circular(999.r),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      child: Text(
        displayLabel,
        style: FontPalette.base600(11, color: textColor),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

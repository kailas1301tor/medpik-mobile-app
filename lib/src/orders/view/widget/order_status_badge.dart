// lib/src/orders/view/widget/order_status_badge.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/utils/helpers/order_status_helper.dart';

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({
    super.key,
    required this.status,
    this.label,
  });

  final OrderStatus status;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final (background, textColor) = orderStatusBadgeColors(status, colors);
    final displayLabel = label ?? orderStatusLabel(status);

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

// lib/src/orders/view/widget/order_tile_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/data/models/order_model.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/orders/view/widget/order_status_badge.dart';

class OrderTileHeader extends StatelessWidget {
  const OrderTileHeader({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final displayId = order.displayOrderId.isNotEmpty
        ? order.displayOrderId
        : Strings.emDash;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                Strings.orderIdLabel,
                style: FontPalette.base400(10, color: colors.secondaryText),
              ),
              2.verticalSpace,
              Text(
                displayId,
                style: FontPalette.base700(15, color: colors.primaryText),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        8.horizontalSpace,
        OrderStatusBadge(
          status: order.status,
          label: order.displayStatus.isNotEmpty ? order.displayStatus : null,
        ),
      ],
    );
  }
}

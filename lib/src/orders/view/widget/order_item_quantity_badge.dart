// lib/src/orders/view/widget/order_item_quantity_badge.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/data/models/order_model.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';

/// Compact quantity line for order items (packs / loose / total).
class OrderItemQuantityBadge extends StatelessWidget {
  const OrderItemQuantityBadge({super.key, required this.item});

  final OrderItemModel item;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final subtitle = item.quantitySubtitle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          item.quantityDisplayLabel,
          style: FontPalette.base400(12, color: colors.secondaryText),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (subtitle != null) ...[
          2.verticalSpace,
          Text(
            subtitle,
            style: FontPalette.base400(11, color: colors.secondaryText),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}

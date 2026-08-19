// lib/src/orders/view/widget/order_ordered_items_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/data/models/order_model.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/src/orders/view/widget/order_detail_section_card.dart';
import 'package:medpik/src/orders/view/widget/order_ordered_item_row.dart';
import 'package:medpik/utils/helpers/order_status_helper.dart';

class OrderOrderedItemsSection extends StatelessWidget {
  const OrderOrderedItemsSection({
    super.key,
    required this.order,
    this.showPrices = true,
  });

  final OrderModel order;
  final bool showPrices;

  @override
  Widget build(BuildContext context) {
    final itemCount = orderItemCount(order);

    return OrderDetailSectionCard(
      title: Strings.orderedItemsWithCount(itemCount),
      titleIcon: Icons.medication_liquid_rounded,
      padding: EdgeInsets.fromLTRB(16.r, 16.r, 16.r, 4.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < order.items.length; i++)
            OrderOrderedItemRow(
              item: order.items[i],
              showPrice: showPrices,
              showDivider: i < order.items.length - 1,
            ),
        ],
      ),
    );
  }
}

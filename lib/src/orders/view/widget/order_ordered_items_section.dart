// lib/src/orders/view/widget/order_ordered_items_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/data/models/order_model.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/orders/view/widget/order_ordered_item_row.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';
import 'package:tsuite/utils/helpers/order_status_helper.dart';

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
    final colors = context.appColors;
    final itemCount = orderItemCount(order);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          Strings.orderedItemsWithCount(itemCount),
          style: FontPalette.base700(16, color: colors.primaryText),
        ),
        8.verticalSpace,
        CommonContainer(
          padding: EdgeInsets.symmetric(horizontal: 16.r),
          borderRadius: 16.r,
          color: colors.surface,
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
        ),
      ],
    );
  }
}

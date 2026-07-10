// lib/src/orders/view/widget/order_tile.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/data/models/order_model.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';
import 'package:tsuite/utils/helpers/order_status_helper.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({
    super.key,
    required this.order,
    required this.onTap,
  });

  final OrderModel order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final statusLabel = orderStatusLabel(order.status);

    return CommonContainer(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      borderRadius: 16.r,
      color: colors.surface,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${Strings.orderIdLabel}: ${order.id}',
                  style: FontPalette.base600(15, color: colors.primaryText),
                ),
              ),
              Text(
                statusLabel,
                style: FontPalette.base600(12, color: colors.primary),
              ),
            ],
          ),
          8.verticalSpace,
          Text(
            '${order.items.length} ${Strings.itemsLabel}',
            style: FontPalette.base400(13, color: colors.secondaryText),
          ),
        ],
      ),
    );
  }
}

// lib/src/orders/view/widget/order_tile.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:tsuite/data/models/order_model.dart';
import 'package:tsuite/res/constants/medpik_svg_assets.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/orders/view/widget/order_product_preview_row.dart';
import 'package:tsuite/src/orders/view/widget/order_status_badge.dart';
import 'package:tsuite/utils/extensions/num_extensions.dart';
import 'package:tsuite/utils/helpers/order_status_helper.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({super.key, required this.order, required this.onTap});

  final OrderModel order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final itemCount = orderItemCount(order);
    final showTotal = orderStatusShowsTotal(order.status) && order.amount > 0;

    return GestureDetector(
      onTap: onTap,
      child: SmoothContainer(
        smoothness: 2,
        side: BorderSide(
          color: colors.cardBorder.withValues(alpha: 0.6),
          width: 1.w,
        ),
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.r),
        borderRadius: BorderRadius.circular(16.r),

        color: colors.surface,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    '${Strings.orderIdLabel}: ${order.id}',
                    style: FontPalette.base700(15, color: colors.primaryText),
                  ),
                ),
                OrderStatusBadge(status: order.status),
                4.horizontalSpace,
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20.r,
                  color: colors.secondaryText,
                ),
              ],
            ),
            6.verticalSpace,
            Row(
              children: [
                SvgPicture.asset(
                  MedpikSvgAssets.calendar,
                  width: 14.r,
                  height: 14.r,
                  fit: BoxFit.contain,
                ),
                6.horizontalSpace,
                Expanded(
                  child: Text(
                    formatOrderDateTime(order.createdAt),
                    style: FontPalette.base400(12, color: colors.secondaryText),
                  ),
                ),
              ],
            ),
            12.verticalSpace,
            OrderProductPreviewRow(items: order.items),
            12.verticalSpace,
            Row(
              children: [
                Text(
                  '$itemCount ${Strings.itemsLabel}',
                  style: FontPalette.base400(12, color: colors.secondaryText),
                ),
                const Spacer(),
                if (showTotal) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        Strings.totalLabel,
                        style: FontPalette.base400(
                          11,
                          color: colors.secondaryText,
                        ),
                      ),
                      2.verticalSpace,
                      Text(
                        order.amount.toCurrency(decimalDigits: 0),
                        style: FontPalette.base700(
                          15,
                          color: colors.primaryText,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

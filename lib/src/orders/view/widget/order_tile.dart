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
import 'package:tsuite/src/orders/view/widget/order_tile_footer.dart';
import 'package:tsuite/utils/helpers/order_status_helper.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({super.key, required this.order, required this.onTap});

  final OrderModel order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final displayId = order.displayOrderId.isNotEmpty
        ? order.displayOrderId
        : Strings.emDash;
    final city = order.address.city.trim();
    final previewUrls = order.previewImageUrls;

    return GestureDetector(
      onTap: onTap,
      child: SmoothContainer(
        smoothness: 2,
        side: BorderSide(color: colors.cardBorder, width: 1.w),
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
                    '${Strings.orderIdLabel}: $displayId',
                    style: FontPalette.base700(15, color: colors.primaryText),
                  ),
                ),
                OrderStatusBadge(
                  status: order.status,
                  label: order.displayStatus.isNotEmpty
                      ? order.displayStatus
                      : null,
                ),
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
            if (city.isNotEmpty) ...[
              4.verticalSpace,
              Text(
                city,
                style: FontPalette.base400(12, color: colors.secondaryText),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (previewUrls.isNotEmpty) ...[
              12.verticalSpace,
              OrderProductPreviewRow(imageUrls: previewUrls),
            ],
            12.verticalSpace,
            OrderTileFooter(order: order),
          ],
        ),
      ),
    );
  }
}

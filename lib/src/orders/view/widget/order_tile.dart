// lib/src/orders/view/widget/order_tile.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medpik/data/models/order_model.dart';
import 'package:medpik/res/constants/medpik_svg_assets.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/src/orders/view/widget/order_product_preview_row.dart';
import 'package:medpik/src/orders/view/widget/order_tile_footer.dart';
import 'package:medpik/src/orders/view/widget/order_tile_glass_card.dart';
import 'package:medpik/src/orders/view/widget/order_tile_header.dart';
import 'package:medpik/src/orders/view/widget/order_tile_meta_row.dart';
import 'package:medpik/utils/helpers/order_status_helper.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({super.key, required this.order, required this.onTap});

  final OrderModel order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final city = order.address.city.trim();
    final locationLabel = city.isNotEmpty ? city : Strings.unavailableValue;
    final previewUrls = order.previewImageUrls;

    return OrderTileGlassCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          OrderTileHeader(order: order),
          8.verticalSpace,
          OrderTileMetaRow(
            items: [
              OrderTileMetaItem(
                icon: SvgPicture.asset(
                  MedpikSvgAssets.calendar,
                  width: 14.r,
                  height: 14.r,
                  colorFilter: ColorFilter.mode(
                    ColorPalette.f13AC00,
                    BlendMode.srcIn,
                  ),
                ),
                value: formatOrderDate(order.createdAt),
              ),
              OrderTileMetaItem(
                icon: Icon(
                  Icons.access_time_rounded,
                  size: 14.r,
                  color: ColorPalette.fCA8E00,
                ),
                value: formatOrderTime(order.createdAt),
              ),
              OrderTileMetaItem(
                icon: SvgPicture.asset(
                  MedpikSvgAssets.location,
                  width: 14.r,
                  height: 14.r,
                  colorFilter: ColorFilter.mode(
                    ColorPalette.red,
                    BlendMode.srcIn,
                  ),
                ),
                value: locationLabel,
              ),
            ],
          ),
          if (previewUrls.isNotEmpty) ...[
            10.verticalSpace,
            OrderProductPreviewRow(imageUrls: previewUrls),
          ],
          10.verticalSpace,
          OrderTileFooter(order: order),
        ],
      ),
    );
  }
}

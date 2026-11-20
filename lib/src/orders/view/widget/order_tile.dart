// lib/src/orders/view/widget/order_tile.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medpik/data/models/order_model.dart';
import 'package:medpik/res/constants/medpik_svg_assets.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
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
    final colors = context.appColors;
    final city = order.address.city.trim();
    final locationLabel = city.isNotEmpty ? city : Strings.unavailableValue;

    return OrderTileGlassCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          OrderTileHeader(order: order),
          14.verticalSpace,
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
                label: Strings.orderDateLabel,
              ),
              OrderTileMetaItem(
                icon: Icon(
                  Icons.access_time_rounded,
                  size: 14.r,
                  color: ColorPalette.fCA8E00,
                ),
                value: formatOrderTime(order.createdAt),
                label: Strings.orderTimeLabel,
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
                label: Strings.orderLocationLabel,
              ),
            ],
          ),
          12.verticalSpace,
          Divider(
            height: 1.h,
            thickness: 1.h,
            color: colors.divider.withValues(alpha: 0.45),
          ),
          12.verticalSpace,
          OrderTileFooter(order: order),
        ],
      ),
    );
  }
}

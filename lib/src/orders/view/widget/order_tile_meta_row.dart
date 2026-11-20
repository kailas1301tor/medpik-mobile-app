// lib/src/orders/view/widget/order_tile_meta_row.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';

class OrderTileMetaRow extends StatelessWidget {
  const OrderTileMetaRow({super.key, required this.items});

  final List<OrderTileMetaItem> items;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0)
            Container(
              width: 1.w,
              height: 36.h,
              margin: EdgeInsets.symmetric(horizontal: 8.w),
              color: colors.divider.withValues(alpha: 0.55),
            ),
          Expanded(child: _OrderTileMetaItemCell(item: items[i])),
        ],
      ],
    );
  }
}

class OrderTileMetaItem {
  const OrderTileMetaItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  final Widget icon;
  final String value;
  final String label;
}

class _OrderTileMetaItemCell extends StatelessWidget {
  const _OrderTileMetaItemCell({required this.item});

  final OrderTileMetaItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            SizedBox(width: 14.r, height: 14.r, child: item.icon),
            4.horizontalSpace,
            Expanded(
              child: Text(
                item.value,
                style: FontPalette.base600(12, color: colors.primaryText),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        4.verticalSpace,
        Text(
          item.label,
          style: FontPalette.base400(10, color: colors.secondaryText),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

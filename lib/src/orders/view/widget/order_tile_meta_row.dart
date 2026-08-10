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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stripColor = isDark
        ? colors.background.withValues(alpha: 0.55)
        : ColorPalette.white.withValues(alpha: 0.55);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: stripColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: colors.cardBorder.withValues(alpha: 0.35),
          width: 1.w,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
        child: Row(
          children: [
            for (var i = 0; i < items.length; i++) ...[
              // if (i > 0)
              //   Container(
              //     width: 1.w,
              //     height: 22.h,
              //     margin: EdgeInsets.symmetric(horizontal: 4.w),
              //     color: colors.divider.withValues(alpha: 0.6),
              //   ),
              Expanded(child: _OrderTileMetaItemCell(item: items[i])),
            ],
          ],
        ),
      ),
    );
  }
}

class OrderTileMetaItem {
  const OrderTileMetaItem({required this.icon, required this.value});

  final Widget icon;
  final String value;
}

class _OrderTileMetaItemCell extends StatelessWidget {
  const _OrderTileMetaItemCell({required this.item});

  final OrderTileMetaItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 14.r, height: 14.r, child: item.icon),
        4.horizontalSpace,
        Expanded(
          child: Text(
            item.value,
            style: FontPalette.base600(11, color: colors.primaryText),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

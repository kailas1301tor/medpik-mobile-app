// lib/src/orders/view/widget/order_ordered_item_row.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/data/models/order_model.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/utils/common_widgets/common_cached_network_image.dart';
import 'package:medpik/utils/extensions/num_extensions.dart';

class OrderOrderedItemRow extends StatelessWidget {
  const OrderOrderedItemRow({
    super.key,
    required this.item,
    this.showPrice = true,
    this.showDivider = true,
  });

  final OrderItemModel item;
  final bool showPrice;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final imageSize = 56.r;
    final product = item.product;
    final showStrikethrough =
        item.hasItemDiscount && item.grossLineTotal > item.lineTotal;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonCachedNetworkImage(
                imageUrl: product.imageUrl,
                width: imageSize,
                height: imageSize,
                borderRadius: 10.r,
                fit: BoxFit.cover,
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product.name,
                      style: FontPalette.base600(14, color: colors.primaryText),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (product.packSize.isNotEmpty) ...[
                      4.verticalSpace,
                      Text(
                        product.packSize,
                        style: FontPalette.base400(
                          12,
                          color: colors.secondaryText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    4.verticalSpace,
                    Text(
                      '${Strings.qtyLabel} ${item.quantity}',
                      style: FontPalette.base400(
                        12,
                        color: colors.secondaryText,
                      ),
                    ),
                    if (item.hasOfferChip) ...[
                      6.verticalSpace,
                      _OrderItemOfferChip(label: item.offerChipLabel),
                    ],
                  ],
                ),
              ),
              if (showPrice) ...[
                8.horizontalSpace,
                _OrderItemPriceColumn(
                  lineTotal: item.lineTotal,
                  grossLineTotal: item.grossLineTotal,
                  showStrikethrough: showStrikethrough,
                ),
              ],
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1.h,
            thickness: 1,
            color: colors.divider.withValues(alpha: 0.7),
          ),
      ],
    );
  }
}

class _OrderItemOfferChip extends StatelessWidget {
  const _OrderItemOfferChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: ColorPalette.successColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        label,
        style: FontPalette.base600(10, color: ColorPalette.successColor),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _OrderItemPriceColumn extends StatelessWidget {
  const _OrderItemPriceColumn({
    required this.lineTotal,
    required this.grossLineTotal,
    required this.showStrikethrough,
  });

  final double lineTotal;
  final double grossLineTotal;
  final bool showStrikethrough;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showStrikethrough)
          Text(
            grossLineTotal.toCurrency(decimalDigits: 0),
            style: FontPalette.base400(12, color: colors.secondaryText)
                .copyWith(
                  decoration: TextDecoration.lineThrough,
                  decorationColor: colors.secondaryText,
                ),
          ),
        Text(
          lineTotal.toCurrency(decimalDigits: 0),
          style: FontPalette.base600(14, color: colors.primaryText),
        ),
      ],
    );
  }
}

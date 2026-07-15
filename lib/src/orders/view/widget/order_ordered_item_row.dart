// lib/src/orders/view/widget/order_ordered_item_row.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/data/models/order_model.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/utils/common_widgets/common_cached_network_image.dart';
import 'package:tsuite/utils/extensions/num_extensions.dart';

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
                memCacheWidth: 112,
                memCacheHeight: 112,
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product.name,
                      style: FontPalette.base600(
                        14,
                        color: colors.primaryText,
                      ),
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
                  ],
                ),
              ),
              if (showPrice) ...[
                8.horizontalSpace,
                Text(
                  item.lineTotal.toCurrency(decimalDigits: 0),
                  style: FontPalette.base600(14, color: colors.primaryText),
                ),
              ],
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1.h,
            thickness: 1,
            color: ColorPalette.orderBillDivider,
          ),
      ],
    );
  }
}

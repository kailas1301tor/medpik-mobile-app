// lib/src/cart/view/widget/cart_item_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/cart/model/cart_item_model.dart';
import 'package:tsuite/utils/common_widgets/common_delete_icon.dart';
import 'package:tsuite/utils/common_widgets/common_cached_network_image.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';
import 'package:tsuite/utils/common_widgets/common_qty_selector.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  final CartItemModel item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final product = item.product;
    final imageSize = 72.r;

    return CommonContainer(
      padding: EdgeInsets.all(12.r),
      borderRadius: 16.r,
      color: colors.surface,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonCachedNetworkImage(
                imageUrl: product.imageUrl,
                width: imageSize,
                height: imageSize,
                borderRadius: 12.r,
                fit: BoxFit.cover,
                memCacheWidth: 144,
                memCacheHeight: 144,
              ),
              12.horizontalSpace,
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 28.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      12.verticalSpace,
                      Align(
                        alignment: Alignment.centerRight,
                        child: CommonQtySelector(
                          quantity: item.quantity,
                          onIncrement: onIncrement,
                          onDecrement: onDecrement,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: onRemove,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: CommonDeleteIcon(size: 24.w),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// lib/src/checkout/view/widget/checkout_product_tile.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/cart/model/cart_item_model.dart';
import 'package:tsuite/utils/common_widgets/common_cached_network_image.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';
import 'package:tsuite/utils/extensions/num_extensions.dart';
import 'package:tsuite/utils/helpers/product_pack_label_helper.dart';

class CheckoutProductTile extends StatelessWidget {
  const CheckoutProductTile({super.key, required this.item});

  final CartItemModel item;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final product = item.product;
    final imageSize = 64.r;
    final packLabel = productPackDisplayLabel(product);
    final subtitle = packLabel.isNotEmpty
        ? packLabel
        : product.category.trim();
    final priceLabel = product.price > 0
        ? item.lineTotal.toCurrency(decimalDigits: 0)
        : Strings.totalAmountSharedAfterReview;

    return CommonContainer(
      padding: EdgeInsets.all(10.r),
      borderRadius: 12.r,
      color: colors.surface,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonCachedNetworkImage(
            imageUrl: product.imageUrl,
            width: imageSize,
            height: imageSize,
            borderRadius: 10.r,
            fit: BoxFit.cover,
            memCacheWidth: 128,
            memCacheHeight: 128,
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: FontPalette.base600(14, color: colors.primaryText),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle.isNotEmpty) ...[
                  4.verticalSpace,
                  Text(
                    subtitle,
                    style: FontPalette.base400(
                      12,
                      color: colors.secondaryText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (product.manufacturerName.isNotEmpty) ...[
                  2.verticalSpace,
                  Text(
                    product.manufacturerName,
                    style: FontPalette.base400(
                      11,
                      color: colors.secondaryText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                8.verticalSpace,
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: ColorPalette.productAccentTeal.withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Text(
                        Strings.quantityTimes(item.quantity),
                        style: FontPalette.base600(
                          11,
                          color: ColorPalette.productAccentTeal,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      priceLabel,
                      style: FontPalette.base700(13, color: colors.primaryText),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

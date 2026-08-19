// lib/src/checkout/view/widget/checkout_product_tile.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/data/models/cart_item_model.dart';
import 'package:medpik/utils/common_widgets/common_cached_network_image.dart';
import 'package:medpik/utils/extensions/num_extensions.dart';
import 'package:medpik/utils/helpers/product_pack_label_helper.dart';

class CheckoutProductTile extends StatelessWidget {
  const CheckoutProductTile({
    super.key,
    required this.item,
    this.showDivider = true,
  });

  final CartItemModel item;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final product = item.product;
    final imageSize = 56.r;
    final packLabel = productPackDisplayLabel(product);
    final subtitle = packLabel.isNotEmpty ? packLabel : product.category.trim();
    final hasPrice = product.price > 0;
    final priceLabel = hasPrice
        ? item.lineTotal.toCurrency(decimalDigits: 0)
        : Strings.totalAmountSharedAfterReview;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
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
              10.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: FontPalette.base600(
                              13,
                              color: colors.primaryText,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        8.horizontalSpace,
                        _CheckoutQtyChip(quantity: item.quantity),
                      ],
                    ),
                    if (subtitle.isNotEmpty) ...[
                      2.verticalSpace,
                      Text(
                        subtitle,
                        style: FontPalette.base400(
                          11,
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
                    6.verticalSpace,
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        priceLabel,
                        textAlign: TextAlign.right,
                        style: hasPrice
                            ? FontPalette.base700(13, color: colors.primaryText)
                            : FontPalette.base500(
                                11,
                                color: colors.secondaryText,
                              ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
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

class _CheckoutQtyChip extends StatelessWidget {
  const _CheckoutQtyChip({required this.quantity});

  final int quantity;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        Strings.quantityTimes(quantity),
        style: FontPalette.base600(11, color: colors.primary),
      ),
    );
  }
}

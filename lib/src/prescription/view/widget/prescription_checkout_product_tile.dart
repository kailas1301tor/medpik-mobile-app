// lib/src/prescription/view/widget/prescription_checkout_product_tile.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/data/models/prescription_selected_product_model.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/utils/common_widgets/common_cached_network_image.dart';
import 'package:medpik/utils/common_widgets/common_container.dart';

class PrescriptionCheckoutProductTile extends StatelessWidget {
  const PrescriptionCheckoutProductTile({super.key, required this.item});

  final PrescriptionSelectedProductModel item;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final product = item.product;
    final imageSize = 40.r;

    return CommonContainer(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.r),
      borderRadius: 12.r,
      color: colors.surface,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(imageSize / 2),
            child: CommonCachedNetworkImage(
              imageUrl: product.imageUrl,
              width: imageSize,
              height: imageSize,
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: FontPalette.base500(14, color: colors.primaryText),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (product.packSize.isNotEmpty) ...[
                  2.verticalSpace,
                  Text(
                    product.packSize,
                    style: FontPalette.base400(12, color: colors.secondaryText),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          12.horizontalSpace,
          Text(
            Strings.quantityTimes(item.quantity),
            style: FontPalette.base400(13, color: colors.secondaryText),
          ),
        ],
      ),
    );
  }
}

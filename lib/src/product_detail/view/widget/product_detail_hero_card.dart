// lib/src/product_detail/view/widget/product_detail_hero_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/product_detail/model/product_detail_model.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_trust_row.dart';
import 'package:medpik/utils/common_widgets/common_cached_network_image.dart';
import 'package:medpik/utils/common_widgets/common_container.dart';
import 'package:medpik/utils/helpers/product_pack_label_helper.dart';

class ProductDetailHeroCard extends StatelessWidget {
  const ProductDetailHeroCard({super.key, required this.detail});

  final ProductDetailModel detail;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final product = detail.product;
    final imageSize = 128.r;
    final packBadge = productPackBadgeLabel(product);

    return CommonContainer(
      padding: EdgeInsets.all(14.r),
      borderRadius: 16.r,
      color: colors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: imageSize,
                    height: imageSize,
                    decoration: BoxDecoration(
                      color: ColorPalette.productImageBg,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    alignment: Alignment.center,
                    child: CommonCachedNetworkImage(
                      imageUrl: product.imageUrl,
                      width: imageSize * 0.75,
                      height: imageSize * 0.75,
                      borderRadius: 0,
                      fit: BoxFit.contain,
                    ),
                  ),
                  if (packBadge.isNotEmpty)
                    Positioned(
                      left: 4.w,
                      bottom: 4.h,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: ColorPalette.productAccentTeal,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.medication_outlined,
                              size: 10.r,
                              color: ColorPalette.white,
                            ),
                            3.horizontalSpace,
                            Text(
                              packBadge,
                              style: FontPalette.base600(
                                9,
                                color: ColorPalette.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: FontPalette.base700(16, color: colors.primaryText),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (detail.specificationLabel.isNotEmpty) ...[
                      4.verticalSpace,
                      Text(
                        detail.specificationLabel,
                        style: FontPalette.base400(
                          12,
                          color: colors.secondaryText,
                        ),
                      ),
                    ],
                    8.verticalSpace,
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: ColorPalette.productAccentTeal.withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Text(
                        product.category,
                        style: FontPalette.base600(
                          11,
                          color: ColorPalette.productAccentTeal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (detail.trustBadges.isNotEmpty) ...[
            16.verticalSpace,
            for (final badge in detail.trustBadges) ...[
              ProductDetailTrustRow(badge: badge),
              if (badge != detail.trustBadges.last) 12.verticalSpace,
            ],
          ],
        ],
      ),
    );
  }
}

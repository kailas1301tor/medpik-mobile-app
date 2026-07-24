// lib/src/product_detail/view/widget/product_detail_trust_row.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/product_detail/model/product_trust_badge_model.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_icon_helper.dart';

class ProductDetailTrustRow extends StatelessWidget {
  const ProductDetailTrustRow({super.key, required this.badge});

  final ProductTrustBadgeModel badge;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32.r,
          height: 32.r,
          decoration: BoxDecoration(
            color: ColorPalette.productAccentTeal.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: ProductDetailIconHelper.build(
            iconKey: badge.iconKey,
            size: 16.r,
            color: ColorPalette.productAccentTeal,
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                badge.title,
                style: FontPalette.base600(13, color: colors.primaryText),
              ),
              2.verticalSpace,
              Text(
                badge.subtitle,
                style: FontPalette.base400(12, color: colors.secondaryText),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

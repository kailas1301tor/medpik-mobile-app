// lib/src/product_detail/view/widget/product_detail_trust_grid.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/product_detail/model/product_trust_badge_model.dart';
import 'package:tsuite/src/product_detail/view/widget/product_detail_icon_helper.dart';

class ProductDetailTrustGrid extends StatelessWidget {
  const ProductDetailTrustGrid({super.key, required this.badges});

  final List<ProductTrustBadgeModel> badges;

  @override
  Widget build(BuildContext context) {
    if (badges.isEmpty) return const SizedBox.shrink();

    final visibleBadges = badges.take(3).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < visibleBadges.length; i++) ...[
          if (i > 0) 8.horizontalSpace,
          Expanded(child: _TrustTile(badge: visibleBadges[i])),
        ],
      ],
    );
  }
}

class _TrustTile extends StatelessWidget {
  const _TrustTile({required this.badge});

  final ProductTrustBadgeModel badge;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      children: [
        Container(
          width: 44.r,
          height: 44.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: ColorPalette.productAccentTeal.withValues(alpha: 0.35),
              width: 1.2.w,
            ),
          ),
          alignment: Alignment.center,
          child: ProductDetailIconHelper.build(
            iconKey: badge.iconKey,
            size: 20.r,
            color: ColorPalette.productAccentTeal,
          ),
        ),
        8.verticalSpace,
        Text(
          badge.title,
          textAlign: TextAlign.center,
          style: FontPalette.base600(11, color: colors.primaryText),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        3.verticalSpace,
        Text(
          badge.subtitle,
          textAlign: TextAlign.center,
          style: FontPalette.base400(9, color: colors.secondaryText),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

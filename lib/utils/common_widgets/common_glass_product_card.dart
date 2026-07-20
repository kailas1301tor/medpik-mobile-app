// lib/utils/common_widgets/common_glass_product_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/utils/common_widgets/common_glass_product_image_hero.dart';
import 'package:tsuite/utils/common_widgets/common_wishlist_button.dart';
import 'package:tsuite/utils/helpers/product_pack_label_helper.dart';

class CommonGlassProductCard extends StatelessWidget {
  const CommonGlassProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.isWishlisted = false,
    this.onWishlistTap,
  });

  final ProductModel product;
  final VoidCallback? onTap;
  final bool isWishlisted;
  final VoidCallback? onWishlistTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final radius = 20.r;
    final imageHeight = 118.h;

    return GestureDetector(
      onTap: onTap,
      child: Material(
        color: colors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: colors.cardBorder, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CommonGlassProductImageHero(
                  product: product,
                  height: imageHeight,
                ),
                if (onWishlistTap != null)
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: CommonWishlistButton(
                      isWishlisted: isWishlisted,
                      onTap: onWishlistTap!,
                      size: 30.r,
                      iconSize: 16.r,
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 12.h),
              child: _CommonGlassProductCardInfo(product: product),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommonGlassProductCardInfo extends StatelessWidget {
  const _CommonGlassProductCardInfo({required this.product});

  final ProductModel product;

  static double get _titleSlotHeight => 36.h;
  static double get _categorySlotHeight => 22.h;
  static double get _packSlotHeight => 14.h;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final packLabel = productPackDisplayLabel(product);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: _titleSlotHeight,
          width: double.infinity,
          child: Text(
            product.name,
            style: FontPalette.base700(14, color: colors.primaryText),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        6.verticalSpace,
        SizedBox(
          height: _categorySlotHeight,
          child: product.category.isEmpty
              ? const SizedBox.shrink()
              : Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
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
                      product.category,
                      style: FontPalette.base600(
                        10,
                        color: ColorPalette.productAccentTeal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
        ),
        6.verticalSpace,
        SizedBox(
          height: _packSlotHeight,
          width: double.infinity,
          child: packLabel.isEmpty
              ? const SizedBox.shrink()
              : Text(
                  packLabel,
                  style: FontPalette.base400(11, color: colors.secondaryText),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
        ),
      ],
    );
  }
}

// lib/src/home/view/widget/home_glass_product_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/home/view/widget/home_glass_product_cta.dart';
import 'package:tsuite/src/home/view/widget/home_glass_product_image_hero.dart';
import 'package:tsuite/src/home/view/widget/home_glass_product_wishlist_button.dart';

class HomeGlassProductCard extends ConsumerStatefulWidget {
  const HomeGlassProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.intrinsic = false,
  });

  final ProductModel product;
  final VoidCallback? onTap;
  final bool intrinsic;

  @override
  ConsumerState<HomeGlassProductCard> createState() =>
      _HomeGlassProductCardState();
}

class _HomeGlassProductCardState extends ConsumerState<HomeGlassProductCard> {
  bool _isWishlisted = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final radius = BorderRadius.circular(16.r);

    return GestureDetector(
      onTap: widget.onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: ColorPalette.productCardBg,
          borderRadius: radius,
          border: Border.all(color: ColorPalette.productCardBorder, width: 1.w),
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: Column(
            mainAxisSize: widget.intrinsic
                ? MainAxisSize.min
                : MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  HomeGlassProductImageHero(product: product, height: 96.h),
                  Positioned(
                    top: 6.h,
                    right: 6.w,
                    child: HomeGlassProductWishlistButton(
                      isWishlisted: _isWishlisted,
                      onTap: () =>
                          setState(() => _isWishlisted = !_isWishlisted),
                    ),
                  ),
                ],
              ),
              if (widget.intrinsic)
                Padding(
                  padding: EdgeInsets.fromLTRB(8.w, 6.h, 8.w, 8.h),
                  child: _CardInfo(
                    product: product,
                    intrinsic: true,
                  ),
                )
              else
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8.w, 6.h, 8.w, 8.h),
                    child: _CardInfo(product: product),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardInfo extends StatelessWidget {
  const _CardInfo({
    required this.product,
    this.intrinsic = false,
  });

  final ProductModel product;
  final bool intrinsic;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final hasPack = product.packSize.isNotEmpty;

    return Column(
      mainAxisSize: intrinsic ? MainAxisSize.min : MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: FontPalette.base700(13, color: colors.primaryText),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (hasPack) ...[
          2.verticalSpace,
          Text(
            product.packSize,
            style: FontPalette.base400(11, color: colors.secondaryText),
          ),
        ],
        if (intrinsic) 4.verticalSpace else const Spacer(),
        Align(
          alignment: Alignment.centerRight,
          child: HomeGlassProductCta(product: product),
        ),
      ],
    );
  }
}

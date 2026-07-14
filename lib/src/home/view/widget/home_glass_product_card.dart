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
import 'package:tsuite/src/wishlist/notifier/wishlist_notifier.dart';
import 'package:tsuite/utils/helpers/product_pack_label_helper.dart';

class HomeGlassProductCard extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final radius = 20.r;
    final imageHeight = 118.h;
    final isWishlisted = ref.watch(
      wishlistNotifierProvider.select(
        (s) => s.items.any((item) => item.id == product.id),
      ),
    );

    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: colors.cardBorder,
            width: 1.w,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                mainAxisSize: intrinsic ? MainAxisSize.min : MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      HomeGlassProductImageHero(
                        product: product,
                        height: imageHeight,
                        topRadius: radius,
                      ),
                      Positioned(
                        top: 8.h,
                        right: 8.w,
                        child: HomeGlassProductWishlistButton(
                          isWishlisted: isWishlisted,
                          onTap: () => ref
                              .read(wishlistNotifierProvider.notifier)
                              .toggle(product),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 12.h),
                    child: _CardInfo(
                      product: product,
                      intrinsic: intrinsic,
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 10.w,
                bottom: 10.h,
                child: HomeGlassProductCta(
                  product: product,
                  compact: true,
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
    final packLabel = productPackDisplayLabel(product);

    return Column(
      mainAxisSize: intrinsic ? MainAxisSize.min : MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 40.w),
          child: Text(
            product.name,
            style: FontPalette.base700(14, color: colors.primaryText),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        6.verticalSpace,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: ColorPalette.productAccentTeal.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(999.r),
          ),
          child: Text(
            product.category,
            style: FontPalette.base600(
              10,
              color: ColorPalette.productAccentTeal,
            ),
          ),
        ),
        if (packLabel.isNotEmpty) ...[
          6.verticalSpace,
          Text(
            packLabel,
            style: FontPalette.base400(11, color: colors.secondaryText),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        28.verticalSpace,
      ],
    );
  }
}

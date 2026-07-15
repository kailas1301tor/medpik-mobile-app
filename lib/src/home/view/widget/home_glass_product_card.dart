// lib/src/home/view/widget/home_glass_product_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/res/constants/app_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/home/view/widget/home_glass_product_image_hero.dart';
import 'package:tsuite/src/home/view/widget/home_glass_product_wishlist_button.dart';
import 'package:tsuite/src/wishlist/notifier/wishlist_notifier.dart';
import 'package:tsuite/utils/helpers/product_pack_label_helper.dart';
import 'package:tsuite/utils/routes/route_constants.dart';

class HomeGlassProductCard extends ConsumerWidget {
  const HomeGlassProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  final ProductModel product;
  final VoidCallback? onTap;

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

    // Material + shape paints the border inset (DecoratedBox borders are
    // half-outside and get clipped by Expanded / Row parents).
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
                HomeGlassProductImageHero(
                  product: product,
                  height: imageHeight,
                ),
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: HomeGlassProductWishlistButton(
                    isWishlisted: isWishlisted,
                    onTap: () {
                      if (!AppConstants.hasSession) {
                        Navigator.pushNamed(
                          context,
                          RouteConstants.routeLoginScreen,
                        );
                        return;
                      }
                      ref
                          .read(wishlistNotifierProvider.notifier)
                          .toggle(product);
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 12.h),
              child: _CardInfo(product: product),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardInfo extends StatelessWidget {
  const _CardInfo({required this.product});

  final ProductModel product;

  /// Fixed slots so every card shares the same height without IntrinsicHeight.
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

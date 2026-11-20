// lib/src/product_detail/view/widget/product_detail_content_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/src/product_detail/model/product_detail_model.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_about_section.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_benefits_section.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_composition_section.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_hero_image.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_how_to_use_section.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_packaging_section.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_quantity_section.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_safety_section.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_storage_section.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_title_section.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_uses_section.dart';
import 'package:medpik/utils/helpers/product_detail_content_resolver.dart';

class ProductDetailContentWidget extends StatelessWidget {
  const ProductDetailContentWidget({
    super.key,
    required this.detail,
    required this.scrollController,
    required this.galleryPageController,
    required this.galleryPageIndex,
    required this.onGalleryPageChanged,
  });

  final ProductDetailModel detail;
  final ScrollController scrollController;
  final PageController galleryPageController;
  final int galleryPageIndex;
  final ValueChanged<int> onGalleryPageChanged;

  /// How far the curved sheet sits up over the fixed gallery.
  static const sheetOverlap = 56.0;
  static const sheetRadius = 32.0;

  static double sheetTopInsetFor(BuildContext context) =>
      ProductDetailHeroImage.heightFor(context) - sheetOverlap.h;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final heroHeight = ProductDetailHeroImage.heightFor(context);
    final overlap = sheetOverlap.h;
    final sheetTopInset = heroHeight - overlap;
    // Sticky bar ≈ 72.h + home-indicator; keep a small gap above it.
    final footerClearance =
        72.h + 16.h + MediaQuery.viewPaddingOf(context).bottom;
    final display = resolveProductDetailDisplay(detail);
    final imageUrls = detail.galleryImageUrls.isNotEmpty
        ? detail.galleryImageUrls
        : [
            if (detail.product.imageUrl.isNotEmpty) detail.product.imageUrl,
          ];
    final topRadius = BorderRadius.vertical(
      top: Radius.circular(sheetRadius.r),
    );

    // Gallery stays behind; curved sheet paints on top and scrolls over it.
    // IgnorePointer on the hero spacer so PageView still receives horizontal swipes.
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: heroHeight,
          child: ProductDetailHeroImage(
            key: ValueKey(detail.product.id),
            imageUrls: imageUrls,
            pageController: galleryPageController,
            activeIndex: galleryPageIndex,
            onPageChanged: onGalleryPageChanged,
            dotsBottomInset: overlap + 12.h,
          ),
        ),
        Positioned.fill(
          child: CustomScrollView(
            controller: scrollController,
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: IgnorePointer(
                  child: SizedBox(height: sheetTopInset),
                ),
              ),
              // Curved sheet — fills remaining viewport when short; grows when tall.
              SliverFillRemaining(
                hasScrollBody: false,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: colors.surface,
                    shape: SmoothRectangleBorder(
                      smoothness: 1.0,
                      borderRadius: topRadius,
                    ),
                    shadows: [
                      BoxShadow(
                        color: ColorPalette.black.withValues(alpha: 0.14),
                        blurRadius: 20,
                        offset: Offset(0, -6.h),
                      ),
                    ],
                  ),
                  child: ClipPath(
                    clipper: ShapeBorderClipper(
                      shape: SmoothRectangleBorder(
                        smoothness: 1.0,
                        borderRadius: topRadius,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        20.w,
                        24.h,
                        20.w,
                        footerClearance,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProductDetailTitleSection(detail: detail),
                          if (display.showPackagings)
                            ProductDetailPackagingSection(
                              packagings: detail.packagings,
                            ),
                          ProductDetailQuantitySection(
                            productId: detail.product.id,
                          ),
                          if (display.showAbout) ...[
                            24.verticalSpace,
                            ProductDetailAboutSection(detail: detail),
                          ],
                          if (display.showComposition) ...[
                            24.verticalSpace,
                            ProductDetailCompositionSection(
                              composition: display.composition,
                            ),
                          ],
                          if (display.showUses) ...[
                            24.verticalSpace,
                            ProductDetailUsesSection(uses: display.uses),
                          ],
                          if (display.showBenefits) ...[
                            24.verticalSpace,
                            ProductDetailBenefitsSection(detail: detail),
                          ],
                          24.verticalSpace,
                          ProductDetailHowToUseSection(
                            howToUse: display.howToUse,
                          ),
                          24.verticalSpace,
                          ProductDetailSafetySection(
                            safetyBlocks: display.safetyBlocks,
                          ),
                          24.verticalSpace,
                          ProductDetailStorageSection(
                            storageBody: display.storageBody,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// lib/src/product_detail/view/widget/product_detail_content_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:medpik/utils/extensions/context_extensions.dart';
import 'package:medpik/utils/helpers/product_detail_content_resolver.dart';

class ProductDetailContentWidget extends StatelessWidget {
  const ProductDetailContentWidget({
    super.key,
    required this.detail,
    required this.scrollController,
  });

  final ProductDetailModel detail;
  final ScrollController scrollController;

  /// How far the sheet overlaps the hero (visual only).
  static const sheetOverlap = 28.0;
  static const _sheetRadius = 28.0;

  static double sheetTopInsetFor(BuildContext context) =>
      ProductDetailHeroImage.heightFor(context) - sheetOverlap.h;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final minSheetHeight =
        context.screenHeight - sheetTopInsetFor(context);
    final footerClearance = 96.h + MediaQuery.paddingOf(context).bottom;
    final display = resolveProductDetailDisplay(detail);

    // Sheet is positioned below the hero in the parent Stack so the PageView
    // receives horizontal swipes. Do not insert a full-width spacer above —
    // that would steal gestures from the gallery.
    return CustomScrollView(
      controller: scrollController,
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(_sheetRadius.r),
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(_sheetRadius.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorPalette.black.withValues(alpha: 0.12),
                    blurRadius: 24,
                    offset: Offset(0, -8.h),
                  ),
                ],
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: minSheetHeight),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 8.h),
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
                      ProductDetailHowToUseSection(howToUse: display.howToUse),
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
        ),
        SliverToBoxAdapter(child: SizedBox(height: footerClearance)),
      ],
    );
  }
}

// lib/src/product_detail/view/widget/product_detail_content_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/src/product_detail/model/product_detail_model.dart';
import 'package:tsuite/src/product_detail/notifier/product_detail_notifier.dart';
import 'package:tsuite/src/product_detail/view/widget/product_detail_about_section.dart';
import 'package:tsuite/src/product_detail/view/widget/product_detail_benefits_section.dart';
import 'package:tsuite/src/product_detail/view/widget/product_detail_hero_image.dart';
import 'package:tsuite/src/product_detail/view/widget/product_detail_how_to_use_section.dart';
import 'package:tsuite/src/product_detail/view/widget/product_detail_safety_section.dart';
import 'package:tsuite/src/product_detail/view/widget/product_detail_title_section.dart';
import 'package:tsuite/src/product_detail/view/widget/product_detail_trust_grid.dart';
import 'package:tsuite/utils/extensions/context_extensions.dart';

class ProductDetailContentWidget extends ConsumerWidget {
  const ProductDetailContentWidget({super.key, required this.detail});

  final ProductDetailModel detail;

  static const _sheetOverlap = 28.0;
  static const _sheetRadius = 28.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final heroHeight = ProductDetailHeroImage.heightFor(context);
    final sheetTopInset = heroHeight - _sheetOverlap.h;
    final minSheetHeight = context.screenHeight - sheetTopInset;
    final footerClearance = 96.h + MediaQuery.paddingOf(context).bottom;
    final scrollController =
        ref.read(productDetailNotifierProvider.notifier).scrollController;

    final hasAbout = detail.aboutText.isNotEmpty;
    final hasTrust = detail.trustBadges.isNotEmpty;
    final hasBenefits = detail.keyBenefits.isNotEmpty;
    final hasHowToUse = detail.howToUse.isNotEmpty;
    final hasSafety = detail.safetyInformation.isNotEmpty;

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: heroHeight,
          child: ProductDetailHeroImage(imageUrl: detail.product.imageUrl),
        ),
        Positioned.fill(
          child: CustomScrollView(
            controller: scrollController,
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: sheetTopInset)),
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
                            if (hasAbout) ...[
                              24.verticalSpace,
                              ProductDetailAboutSection(detail: detail),
                            ],
                            if (hasTrust) ...[
                              24.verticalSpace,
                              ProductDetailTrustGrid(
                                badges: detail.trustBadges,
                              ),
                            ],
                            if (hasBenefits) ...[
                              24.verticalSpace,
                              ProductDetailBenefitsSection(detail: detail),
                            ],
                            if (hasHowToUse) ...[
                              24.verticalSpace,
                              ProductDetailHowToUseSection(detail: detail),
                            ],
                            if (hasSafety) ...[
                              24.verticalSpace,
                              ProductDetailSafetySection(detail: detail),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: footerClearance)),
            ],
          ),
        ),
      ],
    );
  }
}

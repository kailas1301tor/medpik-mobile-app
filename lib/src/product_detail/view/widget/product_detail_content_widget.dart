// lib/src/product_detail/view/widget/product_detail_content_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/src/product_detail/model/product_detail_model.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_about_section.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_benefits_section.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_hero_image.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_how_to_use_section.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_quantity_section.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_safety_section.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_storage_section.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_title_section.dart';
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

  static const _sheetOverlap = 28.0;
  static const _sheetRadius = 28.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final heroHeight = ProductDetailHeroImage.heightFor(context);
    final sheetTopInset = heroHeight - _sheetOverlap.h;
    final minSheetHeight = context.screenHeight - sheetTopInset;
    final footerClearance = 96.h + MediaQuery.paddingOf(context).bottom;
    final display = resolveProductDetailDisplay(detail);

    return CustomScrollView(
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
                      ProductDetailQuantitySection(
                        productId: detail.product.id,
                      ),
                      if (display.showAbout) ...[
                        24.verticalSpace,
                        ProductDetailAboutSection(detail: detail),
                      ],
                      if (display.showBenefits) ...[
                        24.verticalSpace,
                        ProductDetailBenefitsSection(detail: detail),
                      ],
                      24.verticalSpace,
                      ProductDetailHowToUseSection(howToUse: display.howToUse),
                      24.verticalSpace,
                      ProductDetailSafetySection(
                        safetyInformation: display.safetyInformation,
                      ),
                      24.verticalSpace,
                      const ProductDetailStorageSection(),
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

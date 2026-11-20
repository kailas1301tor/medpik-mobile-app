// lib/src/product_detail/view/widget/product_detail_shimmer_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_content_widget.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_floating_action.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_footer_shimmer.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_hero_image.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_shimmer_sections.dart';
import 'package:medpik/utils/common_widgets/common_shimmer_box.dart';

/// Skeleton that mirrors product detail layout while the API loads.
class ProductDetailShimmerWidget extends StatelessWidget {
  const ProductDetailShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final heroHeight = ProductDetailHeroImage.heightFor(context);
    final sheetTopInset = ProductDetailContentWidget.sheetTopInsetFor(context);
    final footerClearance = 72.h + 16.h + bottomInset;
    final topRadius = BorderRadius.vertical(
      top: Radius.circular(ProductDetailContentWidget.sheetRadius.r),
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: heroHeight,
          child: CommonShimmerBox(
            height: heroHeight,
            width: double.infinity,
            borderRadius: 0,
          ),
        ),
        Positioned.fill(
          child: CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: sheetTopInset)),
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
                      child: const ProductDetailSheetBodyShimmer(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: topInset + 8.h,
          left: 16.w,
          child: ProductDetailFloatingAction(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: ProductDetailFooterShimmer(bottomInset: bottomInset),
        ),
      ],
    );
  }
}

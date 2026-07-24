// lib/src/product_detail/view/widget/product_detail_shimmer_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_floating_action.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_hero_image.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_shimmer_sections.dart';
import 'package:medpik/utils/common_widgets/common_shimmer_box.dart';
import 'package:medpik/utils/extensions/context_extensions.dart';

/// Skeleton that mirrors product detail layout while the API loads.
class ProductDetailShimmerWidget extends StatelessWidget {
  const ProductDetailShimmerWidget({super.key});

  static const _sheetOverlap = 28.0;
  static const _sheetRadius = 28.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final heroHeight = ProductDetailHeroImage.heightFor(context);
    final sheetTopInset = heroHeight - _sheetOverlap.h;
    final minSheetHeight = context.screenHeight - sheetTopInset;
    final footerClearance = 96.h + bottomInset;

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
                        child: const ProductDetailSheetBodyShimmer(),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: footerClearance)),
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

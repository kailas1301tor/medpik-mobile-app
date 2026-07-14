// lib/src/prescription/view/widget/prescription_product_grid_tile.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/prescription/view/widget/prescription_product_grid_add_button.dart';
import 'package:tsuite/src/home/view/widget/home_glass_product_image_hero.dart';
import 'package:tsuite/utils/routes/route_constants.dart';

class PrescriptionProductGridTile extends ConsumerWidget {
  const PrescriptionProductGridTile({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final radius = BorderRadius.circular(12.r);
    final hasPack = product.packSize.isNotEmpty;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteConstants.routeProductDetailScreen,
          arguments: product.id,
        );
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: ColorPalette.productCardBg,
          borderRadius: radius,
          border: Border.all(color: ColorPalette.productCardBorder, width: 1.w),
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  HomeGlassProductImageHero(product: product, height: 80.h),
                  Positioned(
                    top: 6.h,
                    right: 6.w,
                    child: PrescriptionProductGridAddButton(product: product),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8.w, 6.h, 8.w, 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          product.name,
                          style: FontPalette.base700(
                            11,
                            color: colors.primaryText,
                          ).copyWith(height: 1.2),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasPack) ...[
                        2.verticalSpace,
                        Text(
                          product.packSize,
                          style: FontPalette.base400(
                            9,
                            color: colors.secondaryText,
                          ).copyWith(height: 1.2),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

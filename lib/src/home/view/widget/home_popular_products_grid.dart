// lib/src/home/view/widget/home_popular_products_grid.dart
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/src/home/view/widget/home_glass_product_card.dart';
import 'package:tsuite/utils/routes/route_constants.dart';

/// 2-column popular products grid for the home [CustomScrollView].
abstract final class HomePopularProductsGrid {
  static const int maxItems = 10;

  static Widget sliver({required List<ProductModel> products}) {
    final items = products.take(maxItems).toList();
    if (items.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final count = math.min(maxItems, items.length);

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 8.h),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 12.w,
          childAspectRatio: 0.62,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = items[index];
            return HomeGlassProductCard(
              product: product,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  RouteConstants.routeProductDetailScreen,
                  arguments: product.id,
                );
              },
            );
          },
          childCount: count,
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: true,
        ),
      ),
    );
  }
}

// lib/src/home/view/widget/home_popular_products_grid.dart
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/src/home/view/widget/home_product_card.dart';

/// 2-column popular products list for the home [CustomScrollView].
/// Uses content-sized rows (not a fixed aspect-ratio grid) so cards
/// only occupy the height they need.
abstract final class HomePopularProductsGrid {
  static const int maxItems = 10;

  static Widget sliver({required List<ProductModel> products}) {
    final items = products.take(maxItems).toList();
    if (items.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final count = math.min(maxItems, items.length);
    final rowCount = (count / 2).ceil();

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 8.h),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, rowIndex) {
            final leftIndex = rowIndex * 2;
            final rightIndex = leftIndex + 1;
            final left = items[leftIndex];
            final right = rightIndex < count ? items[rightIndex] : null;

            return Padding(
              padding: EdgeInsets.only(
                bottom: rowIndex < rowCount - 1 ? 12.h : 0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _productCard(context, left)),
                  12.horizontalSpace,
                  Expanded(
                    child: right == null
                        ? const SizedBox.shrink()
                        : _productCard(context, right),
                  ),
                ],
              ),
            );
          },
          childCount: rowCount,
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: true,
        ),
      ),
    );
  }

  static Widget _productCard(BuildContext context, ProductModel product) {
    return HomeProductCard(product: product);
  }
}

// lib/src/home/view/widget/home_product_rail.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/data/models/product_model.dart';
import 'package:medpik/src/home/view/widget/home_product_card.dart';

/// Horizontal product strip for home feed sections (max [maxItems]).
class HomeProductRail extends StatelessWidget {
  const HomeProductRail({
    super.key,
    required this.products,
  });

  static const int maxItems = 10;

  /// Matches [CommonGlassProductCard] layout + rail vertical padding.
  static double get height {
    const image = 118.0;
    const infoPadV = 10.0 + 12.0;
    const title = 36.0;
    const gapAfterTitle = 6.0;
    const category = 22.0;
    const gapAfterCategory = 6.0;
    const pack = 14.0;
    const cardBorder = 2.0;
    const listPadV = 4.0 + 8.0;
    return (image +
            infoPadV +
            title +
            gapAfterTitle +
            category +
            gapAfterCategory +
            pack +
            cardBorder +
            listPadV)
        .h;
  }

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    final items = products.take(maxItems).toList(growable: false);
    if (items.isEmpty) return const SizedBox.shrink();

    final cardWidth = 148.w;

    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 8.h),
        itemCount: items.length,
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              right: index < items.length - 1 ? 12.w : 0,
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: cardWidth,
                child: HomeProductCard(product: items[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}

// lib/src/wishlist/view/widget/wishlist_content_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/src/home/view/widget/home_glass_product_card.dart';
import 'package:tsuite/utils/routes/route_constants.dart';

class WishlistContentWidget extends ConsumerWidget {
  const WishlistContentWidget({super.key, required this.items});

  final List<ProductModel> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.62,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final product = items[index];
        return RepaintBoundary(
          child: HomeGlassProductCard(
            product: product,
            onTap: () {
              Navigator.pushNamed(
                context,
                RouteConstants.routeProductDetailScreen,
                arguments: product.id,
              );
            },
          ),
        );
      },
    );
  }
}

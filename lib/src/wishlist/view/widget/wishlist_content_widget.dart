// lib/src/wishlist/view/widget/wishlist_content_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/src/wishlist/view/widget/wishlist_product_card.dart';

/// 2-column wishlist list using content-sized rows (not a fixed
/// aspect-ratio grid) so cards only occupy the height they need.
class WishlistContentWidget extends StatelessWidget {
  const WishlistContentWidget({
    super.key,
    required this.items,
    required this.onWishlistTap,
  });

  final List<ProductModel> items;
  final void Function(ProductModel product) onWishlistTap;

  @override
  Widget build(BuildContext context) {
    final rowCount = (items.length / 2).ceil();

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
      physics: const AlwaysScrollableScrollPhysics(),
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      itemCount: rowCount,
      itemBuilder: (context, rowIndex) {
        final leftIndex = rowIndex * 2;
        final rightIndex = leftIndex + 1;
        final left = items[leftIndex];
        final right = rightIndex < items.length ? items[rightIndex] : null;

        return Padding(
          padding: EdgeInsets.only(
            bottom: rowIndex < rowCount - 1 ? 12.h : 0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _productCard(left)),
              12.horizontalSpace,
              Expanded(
                child: right == null
                    ? const SizedBox.shrink()
                    : _productCard(right),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _productCard(ProductModel product) {
    return RepaintBoundary(
      child: WishlistProductCard(
        product: product,
        onWishlistTap: () => onWishlistTap(product),
      ),
    );
  }
}

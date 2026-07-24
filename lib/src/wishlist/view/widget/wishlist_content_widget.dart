// lib/src/wishlist/view/widget/wishlist_content_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/data/models/product_model.dart';
import 'package:medpik/src/wishlist/notifier/wishlist_notifier.dart';
import 'package:medpik/src/wishlist/view/widget/wishlist_product_card.dart';

/// 2-column wishlist list using content-sized rows (not a fixed
/// aspect-ratio grid) so cards only occupy the height they need.
class WishlistContentWidget extends ConsumerWidget {
  const WishlistContentWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(
      wishlistNotifierProvider.select((s) => s.items),
    );
    final notifier = ref.read(wishlistNotifierProvider.notifier);
    final rowCount = (items.length / 2).ceil();

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
      physics: const AlwaysScrollableScrollPhysics(),
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      itemCount: rowCount,
      itemBuilder: (context, rowIndex) {
        final leftIndex = rowIndex * 2;
        final rightIndex = leftIndex + 1;

        return Padding(
          padding: EdgeInsets.only(
            bottom: rowIndex < rowCount - 1 ? 12.h : 0,
          ),
          child: _WishlistProductRow(
            left: items[leftIndex],
            right: rightIndex < items.length ? items[rightIndex] : null,
            onWishlistTap: notifier.toggle,
          ),
        );
      },
    );
  }
}

class _WishlistProductRow extends StatelessWidget {
  const _WishlistProductRow({
    required this.left,
    required this.right,
    required this.onWishlistTap,
  });

  final ProductModel left;
  final ProductModel? right;
  final Future<bool> Function(ProductModel product) onWishlistTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: WishlistProductCard(
            product: left,
            onWishlistTap: () => onWishlistTap(left),
          ),
        ),
        12.horizontalSpace,
        Expanded(
          child: right == null
              ? const SizedBox.shrink()
              : WishlistProductCard(
                  product: right!,
                  onWishlistTap: () => onWishlistTap(right!),
                ),
        ),
      ],
    );
  }
}

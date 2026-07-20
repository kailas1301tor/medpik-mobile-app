// lib/services/wishlist_facade_service.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/src/wishlist/notifier/wishlist_notifier.dart';

part 'wishlist_facade_service.g.dart';

@Riverpod(keepAlive: true)
WishlistFacadeService wishlistFacadeService(Ref ref) {
  return WishlistFacadeService(ref);
}

@Riverpod(keepAlive: true)
bool isProductWishlisted(Ref ref, int productId) {
  return ref.watch(
    wishlistNotifierProvider.select(
      (s) => s.items.any((item) => item.id == productId),
    ),
  );
}

class WishlistFacadeService {
  const WishlistFacadeService(this._ref);

  final Ref _ref;

  bool isWishlisted(int productId) {
    return _ref.read(wishlistNotifierProvider.notifier).isWishlisted(productId);
  }

  Future<void> fetchWishlist() {
    return _ref.read(wishlistNotifierProvider.notifier).fetchWishlist();
  }

  void syncFromProducts(List<ProductModel> products) {
    _ref.read(wishlistNotifierProvider.notifier).syncFromProducts(products);
  }

  Future<bool> toggle(ProductModel product) {
    return _ref.read(wishlistNotifierProvider.notifier).toggle(product);
  }

  void clear() {
    _ref.read(wishlistNotifierProvider.notifier).clear();
  }
}

// lib/src/wishlist/notifier/wishlist_notifier.dart
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/src/wishlist/state/wishlist_state.dart';

part 'wishlist_notifier.g.dart';

@Riverpod(keepAlive: true)
class WishlistNotifier extends _$WishlistNotifier {
  @override
  WishlistState build() => const WishlistState();

  bool isWishlisted(int productId) {
    return state.items.any((item) => item.id == productId);
  }

  void toggle(ProductModel product) {
    final items = [...state.items];
    final index = items.indexWhere((item) => item.id == product.id);

    if (index >= 0) {
      items.removeAt(index);
      debugPrint("🟡 WISHLIST: removed ${product.name}");
    } else {
      items.add(product);
      debugPrint("🟢 WISHLIST: added ${product.name}");
    }

    state = state.copyWith(items: items);
  }

  void remove(int productId) {
    final items = state.items.where((item) => item.id != productId).toList();
    debugPrint("🟡 WISHLIST: removed productId=$productId");
    state = state.copyWith(items: items);
  }
}

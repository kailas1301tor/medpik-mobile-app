// lib/services/cart_facade_service.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/src/cart/model/cart_item_model.dart';
import 'package:tsuite/src/cart/notifier/cart_notifier.dart';

part 'cart_facade_service.g.dart';

@Riverpod(keepAlive: true)
CartFacadeService cartFacadeService(Ref ref) {
  return CartFacadeService(ref);
}

@Riverpod(keepAlive: true)
List<CartItemModel> cartItems(Ref ref) {
  return ref.watch(cartNotifierProvider.select((s) => s.items));
}

@Riverpod(keepAlive: true)
int cartTotalItemCount(Ref ref) {
  return ref.watch(
    cartNotifierProvider.select(
      (s) => s.items.fold<int>(0, (sum, item) => sum + item.quantity),
    ),
  );
}

@Riverpod(keepAlive: true)
int cartProductQuantity(Ref ref, int productId) {
  return ref.watch(
    cartNotifierProvider.select((s) {
      for (final item in s.items) {
        if (item.product.id == productId) return item.quantity;
      }
      return 0;
    }),
  );
}

class CartFacadeService {
  const CartFacadeService(this._ref);

  final Ref _ref;

  List<CartItemModel> get items => _ref.read(cartItemsProvider);

  int quantityForProduct(int productId) {
    return _ref.read(cartProductQuantityProvider(productId));
  }

  Future<bool> addItem({
    required ProductModel product,
    required int quantity,
  }) {
    return _ref
        .read(cartNotifierProvider.notifier)
        .addItem(product: product, quantity: quantity);
  }

  Future<void> incrementItem(int productId) {
    return _ref.read(cartNotifierProvider.notifier).incrementItem(productId);
  }

  Future<void> decrementItem(int productId) {
    return _ref.read(cartNotifierProvider.notifier).decrementItem(productId);
  }

  Future<void> fetchCart({bool showLoader = false}) {
    return _ref
        .read(cartNotifierProvider.notifier)
        .fetchCart(showLoader: showLoader);
  }
}

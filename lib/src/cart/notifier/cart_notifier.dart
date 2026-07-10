// lib/src/cart/notifier/cart_notifier.dart
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/src/cart/model/cart_item_model.dart';
import 'package:tsuite/src/cart/state/cart_state.dart';

part 'cart_notifier.g.dart';

@Riverpod(keepAlive: true)
class CartNotifier extends _$CartNotifier {
  @override
  CartState build() => const CartState();

  void addItem({required ProductModel product, required int quantity}) {
    final items = [...state.items];
    final index = items.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      final existing = items[index];
      items[index] = existing.copyWith(
        quantity: existing.quantity + quantity,
      );
    } else {
      items.add(CartItemModel(product: product, quantity: quantity));
    }

    debugPrint("🟢 CART: added ${product.name} x$quantity");
    state = state.copyWith(items: items);
  }

  void incrementItem(int productId) {
    final items = state.items.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(quantity: item.quantity + 1);
      }
      return item;
    }).toList();
    state = state.copyWith(items: items);
  }

  void decrementItem(int productId) {
    final items = <CartItemModel>[];
    for (final item in state.items) {
      if (item.product.id != productId) {
        items.add(item);
        continue;
      }
      if (item.quantity > 1) {
        items.add(item.copyWith(quantity: item.quantity - 1));
      }
    }
    state = state.copyWith(items: items);
  }

  void removeItem(int productId) {
    state = state.copyWith(
      items: state.items.where((item) => item.product.id != productId).toList(),
    );
  }

  double get subtotal =>
      state.items.fold(0, (sum, item) => sum + item.lineTotal);

  void clearCart() {
    state = state.copyWith(items: []);
    debugPrint("🔵 CART: cleared");
  }
}

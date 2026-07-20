// lib/src/cart/notifier/cart_notifier.dart
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/res/constants/app_constants.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/src/cart/model/cart_item_model.dart';
import 'package:tsuite/src/cart/repo/cart_repository.dart';
import 'package:tsuite/src/cart/state/cart_state.dart';
import 'package:tsuite/services/repo_di.dart';
import 'package:tsuite/utils/common_widgets/custom_toast.dart';
import 'package:tsuite/utils/helpers/api_error_handler.dart';

part 'cart_notifier.g.dart';

@Riverpod(keepAlive: true)
class CartNotifier extends _$CartNotifier {
  late CartRepo cartRepo;

  Future<void> _mutationChain = Future.value();
  bool _hasFetchedOnce = false;
  int _tempLineIdSeq = 0;

  @override
  CartState build() {
    cartRepo = ref.read(cartRepositoryProvider);

    Future.microtask(() {
      if (AppConstants.hasSession) {
        fetchCart(showLoader: false);
      }
    });

    return const CartState();
  }

  CartItemModel? _itemForProduct(int productId) {
    for (final item in state.items) {
      if (item.product.id == productId) return item;
    }
    return null;
  }

  List<CartItemModel> _snapshotItems() =>
      List<CartItemModel>.from(state.items);

  void _restoreItems(List<CartItemModel> snapshot) {
    state = state.copyWith(
      items: snapshot,
      loaderState: snapshot.isEmpty ? LoaderState.noData : LoaderState.loaded,
    );
  }

  void _setItems(List<CartItemModel> items) {
    state = state.copyWith(
      items: items,
      loaderState: items.isEmpty ? LoaderState.noData : LoaderState.loaded,
    );
  }

  int _nextTempLineId() {
    _tempLineIdSeq += 1;
    return -(_tempLineIdSeq + DateTime.now().millisecondsSinceEpoch);
  }

  Future<T> _enqueueMutation<T>(Future<T> Function() action) {
    final run = _mutationChain.then((_) async {
      state = state.copyWith(isMutating: true);
      try {
        return await action();
      } finally {
        state = state.copyWith(isMutating: false);
      }
    });
    _mutationChain = run.then(
      (_) {},
      onError: (_) {},
    );
    return run;
  }

  Future<void> fetchCart({bool showLoader = true}) async {
    if (!AppConstants.hasSession) {
      state = state.copyWith(
        items: const [],
        isMutating: false,
        loaderState: LoaderState.noData,
      );
      return;
    }

    if (showLoader || !_hasFetchedOnce) {
      state = state.copyWith(loaderState: LoaderState.loading);
    }

    return await cartRepo
        .getCart()
        .fold(
          (error) {
            final loaderState = handleResponseError(error.key);
            debugPrint("🔴 CART FETCH ERROR: ${error.message}");
            state = state.copyWith(loaderState: loaderState);
            showCustomToast(
              message: error.message ?? Strings.somethingWentWrong,
              isSuccess: false,
            );
          },
          (response) {
            _hasFetchedOnce = true;
            final items = response.items;
            debugPrint("🟢 CART FETCH: ${items.length} item(s)");
            state = state.copyWith(
              items: items,
              loaderState:
                  items.isEmpty ? LoaderState.noData : LoaderState.loaded,
            );
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED CART FETCH ERROR: $error");
          state = state.copyWith(loaderState: LoaderState.error);
          showCustomToast(
            message: Strings.somethingWentWrong,
            isSuccess: false,
          );
        });
  }

  Future<bool> addItem({
    required ProductModel product,
    required int quantity,
  }) {
    return _enqueueMutation(
      () => _addItem(product: product, quantity: quantity),
    );
  }

  Future<bool> _addItem({
    required ProductModel product,
    required int quantity,
  }) async {
    if (quantity <= 0) return false;
    if (!AppConstants.hasSession) {
      showCustomToast(message: Strings.loginToAddToCart, isSuccess: false);
      return false;
    }

    final snapshot = _snapshotItems();
    final existing = _itemForProduct(product.id);
    if (existing != null) {
      _setItems([
        for (final item in state.items)
          if (item.product.id == product.id)
            item.copyWith(quantity: item.quantity + quantity)
          else
            item,
      ]);
    } else {
      _setItems([
        ...state.items,
        CartItemModel(
          id: _nextTempLineId(),
          product: product,
          quantity: quantity,
        ),
      ]);
    }

    return await cartRepo
        .addToCart(productId: product.id, quantity: quantity)
        .fold(
          (error) {
            debugPrint("🔴 CART ADD ERROR: ${error.message}");
            _restoreItems(snapshot);
            showCustomToast(
              message: error.message ?? Strings.somethingWentWrong,
              isSuccess: false,
            );
            return false;
          },
          (_) async {
            debugPrint("🟢 CART: added ${product.name} x$quantity");
            await fetchCart(showLoader: false);
            return true;
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED CART ADD ERROR: $error");
          _restoreItems(snapshot);
          showCustomToast(
            message: Strings.somethingWentWrong,
            isSuccess: false,
          );
          return false;
        });
  }

  Future<void> incrementItem(int productId) {
    return _enqueueMutation(() => _incrementItem(productId));
  }

  Future<void> _incrementItem(int productId) async {
    if (!AppConstants.hasSession) return;

    final existing = _itemForProduct(productId);
    if (existing == null) return;

    final snapshot = _snapshotItems();
    _setItems([
      for (final item in state.items)
        if (item.product.id == productId)
          item.copyWith(quantity: item.quantity + 1)
        else
          item,
    ]);

    return await cartRepo
        .addToCart(productId: productId, quantity: 1)
        .fold(
          (error) {
            debugPrint("🔴 CART INCREMENT ERROR: ${error.message}");
            _restoreItems(snapshot);
            showCustomToast(
              message: error.message ?? Strings.somethingWentWrong,
              isSuccess: false,
            );
          },
          (_) async {
            debugPrint("🔵 ACTION: cart qty +1 product_id=$productId");
            await fetchCart(showLoader: false);
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED CART INCREMENT ERROR: $error");
          _restoreItems(snapshot);
          showCustomToast(
            message: Strings.somethingWentWrong,
            isSuccess: false,
          );
        });
  }

  Future<void> decrementItem(int productId) {
    return _enqueueMutation(() => _decrementItem(productId));
  }

  Future<void> _decrementItem(int productId) async {
    if (!AppConstants.hasSession) return;

    final item = _itemForProduct(productId);
    if (item == null) return;

    if (item.quantity <= 1) {
      await _removeByLineId(item.id);
      return;
    }

    final snapshot = _snapshotItems();
    final nextQty = item.quantity - 1;
    _setItems([
      for (final entry in state.items)
        if (entry.product.id == productId)
          entry.copyWith(quantity: nextQty)
        else
          entry,
    ]);

    // Temp lines have no server id yet — skip network until reconcile.
    if (item.id <= 0) {
      debugPrint("🔵 ACTION: cart qty -1 (temp line) product_id=$productId");
      return;
    }

    return await cartRepo
        .removeCartItems(itemIds: [item.id])
        .fold(
          (error) {
            debugPrint("🔴 CART DECREMENT REMOVE ERROR: ${error.message}");
            _restoreItems(snapshot);
            showCustomToast(
              message: error.message ?? Strings.somethingWentWrong,
              isSuccess: false,
            );
          },
          (_) async {
            await cartRepo
                .addToCart(productId: productId, quantity: nextQty)
                .fold(
                  (error) {
                    debugPrint(
                      "🔴 CART DECREMENT RE-ADD ERROR: ${error.message}",
                    );
                    _restoreItems(snapshot);
                    showCustomToast(
                      message: error.message ?? Strings.somethingWentWrong,
                      isSuccess: false,
                    );
                  },
                  (_) async {
                    debugPrint(
                      "🔵 ACTION: cart qty -1 product_id=$productId",
                    );
                    await fetchCart(showLoader: false);
                  },
                )
                .catchError((error) {
                  debugPrint(
                    "🔴 UNEXPECTED CART DECREMENT RE-ADD ERROR: $error",
                  );
                  _restoreItems(snapshot);
                  showCustomToast(
                    message: Strings.somethingWentWrong,
                    isSuccess: false,
                  );
                });
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED CART DECREMENT ERROR: $error");
          _restoreItems(snapshot);
          showCustomToast(
            message: Strings.somethingWentWrong,
            isSuccess: false,
          );
        });
  }

  Future<void> removeItem(int productId) {
    return _enqueueMutation(() async {
      final item = _itemForProduct(productId);
      if (item == null) return;
      await _removeByLineId(item.id);
    });
  }

  Future<void> removeCartLine(int lineId) {
    return _enqueueMutation(() => _removeByLineId(lineId));
  }

  Future<void> _removeByLineId(int lineId) async {
    if (!AppConstants.hasSession) return;

    final snapshot = _snapshotItems();
    final next = state.items.where((e) => e.id != lineId).toList();
    _setItems(next);

    // Optimistic-only temp lines never hit DELETE.
    if (lineId <= 0) {
      debugPrint("🔵 ACTION: removed temp cart line id=$lineId");
      return;
    }

    return await cartRepo
        .removeCartItems(itemIds: [lineId])
        .fold(
          (error) {
            debugPrint("🔴 CART REMOVE ERROR: ${error.message}");
            _restoreItems(snapshot);
            showCustomToast(
              message: error.message ?? Strings.somethingWentWrong,
              isSuccess: false,
            );
          },
          (_) async {
            debugPrint("🔵 ACTION: removed cart line id=$lineId");
            await fetchCart(showLoader: false);
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED CART REMOVE ERROR: $error");
          _restoreItems(snapshot);
          showCustomToast(
            message: Strings.somethingWentWrong,
            isSuccess: false,
          );
        });
  }

  Future<void> clearCart() {
    return _enqueueMutation(_clearCart);
  }

  Future<void> _clearCart() async {
    if (!AppConstants.hasSession) {
      state = state.copyWith(
        items: const [],
        loaderState: LoaderState.noData,
      );
      return;
    }

    final snapshot = _snapshotItems();
    final ids = snapshot.map((e) => e.id).where((id) => id > 0).toList();
    _setItems(const []);

    if (ids.isEmpty) {
      return;
    }

    return await cartRepo
        .removeCartItems(itemIds: ids)
        .fold(
          (error) {
            debugPrint("🔴 CART CLEAR ERROR: ${error.message}");
            _restoreItems(snapshot);
            showCustomToast(
              message: error.message ?? Strings.somethingWentWrong,
              isSuccess: false,
            );
          },
          (_) async {
            debugPrint("🔵 CART: cleared");
            await fetchCart(showLoader: false);
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED CART CLEAR ERROR: $error");
          _restoreItems(snapshot);
          showCustomToast(
            message: Strings.somethingWentWrong,
            isSuccess: false,
          );
        });
  }

  double get subtotal =>
      state.items.fold(0, (sum, item) => sum + item.lineTotal);

  int get totalItemCount =>
      state.items.fold<int>(0, (sum, item) => sum + item.quantity);

  void clearSessionCart() {
    _hasFetchedOnce = false;
    state = const CartState(loaderState: LoaderState.noData);
  }
}

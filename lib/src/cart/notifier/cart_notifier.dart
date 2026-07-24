// lib/src/cart/notifier/cart_notifier.dart
//
// * Cart feature — API-driven session cart.
//
// ? Module role: owns cart items, screen loader state, and mutation-in-flight flag.
// ? All writes call the API first; items update only after a successful GET /cart.
//
// ! keepAlive: true — cart badge, product detail, and checkout read cart across tabs.
//
// * Entry points: CartScreen, ProductDetail, Checkout, bottom nav badge, AuthNotifier sync.
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/data/models/cart_item_model.dart';
import 'package:medpik/data/models/product_model.dart';
import 'package:medpik/res/constants/app_constants.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/services/repo_di.dart';
import 'package:medpik/src/cart/repo/cart_repository.dart';
import 'package:medpik/src/cart/state/cart_state.dart';
import 'package:medpik/utils/helpers/api_error_handler.dart';
import 'package:medpik/utils/helpers/toast_helper.dart';

part 'cart_notifier.g.dart';

@Riverpod(keepAlive: true)
class CartNotifier extends _$CartNotifier {
  late CartRepo cartRepo;

  @override
  CartState build() {
    cartRepo = ref.read(cartRepositoryProvider);

    Future.microtask(() {
      if (AppConstants.hasSession) {
        fetchCart(showLoader: false);
      }
    });

    return CartState(
      loaderState: AppConstants.hasSession
          ? LoaderState.loading
          : LoaderState.noData,
    );
  }

  // ? GET /api/cart — drives CartScreen loader / empty / error states.
  Future<void> fetchCart({bool showLoader = true}) async {
    if (showLoader) {
      state = state.copyWith(loaderState: LoaderState.loading);
    }
    return await cartRepo
        .getCart()
        .fold(
          (left) {
            final loaderState = handleResponseError(left.key);
            debugPrint("🔴 CART FETCH ERROR: ${left.message}");
            if (showLoader) {
              state = state.copyWith(loaderState: loaderState);
              showCustomErrorToast(
                message: left.message ?? Strings.somethingWentWrong,
              );
            }
          },
          (right) {
            final items = right.items;
            debugPrint("🟢 CART FETCH: ${items.length} item(s)");
            state = state.copyWith(
              items: items,
              loaderState: items.isEmpty
                  ? LoaderState.noData
                  : LoaderState.loaded,
            );
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED CART FETCH ERROR: $error");
          if (showLoader) {
            state = state.copyWith(loaderState: LoaderState.error);
          }
        });
  }

  // ? POST /api/cart — add product or bump quantity.
  Future<bool> addItem({
    required ProductModel product,
    required int quantity,
  }) async {
    if (quantity <= 0) return false;
    if (!AppConstants.hasSession) {
      showCustomErrorToast(message: Strings.loginToAddToCart);
      return false;
    }
    if (state.isMutating) return false;

    state = state.copyWith(isMutating: true);
    var succeeded = false;
    await cartRepo
        .addToCart(productId: product.id, quantity: quantity)
        .fold(
          (left) {
            debugPrint("🔴 CART ADD ERROR: ${left.message}");
            showCustomErrorToast(
              message: left.message ?? Strings.somethingWentWrong,
            );
          },
          (right) async {
            debugPrint("🟢 CART ADD SUCCESS: ${product.name} x$quantity");
            await fetchCart(showLoader: false);
            succeeded = true;
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED CART ADD ERROR: $error");
          showCustomErrorToast(message: Strings.somethingWentWrong);
        });
    state = state.copyWith(isMutating: false);
    return succeeded;
  }

  // ? POST /api/cart quantity=+1.
  Future<void> incrementItem(int productId) async {
    if (!AppConstants.hasSession || state.isMutating) return;

    state = state.copyWith(isMutating: true);
    await cartRepo
        .addToCart(productId: productId, quantity: 1)
        .fold(
          (left) {
            debugPrint("🔴 CART INCREMENT ERROR: ${left.message}");
            showCustomErrorToast(
              message: left.message ?? Strings.somethingWentWrong,
            );
          },
          (right) async {
            debugPrint("🟢 CART INCREMENT SUCCESS: product_id=$productId");
            await fetchCart(showLoader: false);
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED CART INCREMENT ERROR: $error");
          showCustomErrorToast(message: Strings.somethingWentWrong);
        });
    state = state.copyWith(isMutating: false);
  }

  // ? Decrement — API rejects negative quantity; re-set line via remove + add.
  Future<void> decrementItem(int productId) async {
    if (state.isMutating) return;

    final cartItem = _findItemByProductId(productId);
    if (cartItem == null) return;

    if (cartItem.quantity <= 1) {
      await removeCartLine(cartItem.id);
      return;
    }

    state = state.copyWith(isMutating: true);
    await cartRepo
        .setCartLineQuantity(
          productId: productId,
          lineId: cartItem.id,
          quantity: cartItem.quantity - 1,
        )
        .fold(
          (left) {
            debugPrint("🔴 CART DECREMENT ERROR: ${left.message}");
            showCustomErrorToast(
              message: left.message ?? Strings.somethingWentWrong,
            );
          },
          (right) async {
            debugPrint("🟢 CART DECREMENT SUCCESS: product_id=$productId");
            await fetchCart(showLoader: false);
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED CART DECREMENT ERROR: $error");
          showCustomErrorToast(message: Strings.somethingWentWrong);
        });
    state = state.copyWith(isMutating: false);
  }

  // ? DELETE /api/cart — remove one line.
  Future<void> removeCartLine(int lineId) async {
    if (state.isMutating) return;

    state = state.copyWith(isMutating: true);
    await cartRepo
        .removeCartItems(itemIds: [lineId])
        .fold(
          (left) {
            debugPrint("🔴 CART REMOVE ERROR: ${left.message}");
            showCustomErrorToast(
              message: left.message ?? Strings.somethingWentWrong,
            );
          },
          (right) async {
            debugPrint("🟢 CART REMOVE SUCCESS: line_id=$lineId");
            await fetchCart(showLoader: false);
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED CART REMOVE ERROR: $error");
          showCustomErrorToast(message: Strings.somethingWentWrong);
        });
    state = state.copyWith(isMutating: false);
  }

  // ? DELETE /api/cart — remove all lines, then reconcile with GET /cart.
  Future<void> clearCart({bool showErrors = true}) async {
    if (state.isMutating) return;

    final lineIds = state.items.map((e) => e.id).toList();
    state = state.copyWith(isMutating: true);
    if (lineIds.isNotEmpty) {
      await cartRepo
          .removeCartItems(itemIds: lineIds)
          .fold(
            (left) {
              debugPrint("🔴 CART CLEAR ERROR: ${left.message}");
              if (showErrors) {
                showCustomErrorToast(
                  message: left.message ?? Strings.somethingWentWrong,
                );
              }
            },
            (right) async {
              debugPrint("🟢 CART CLEAR SUCCESS");
            },
          )
          .catchError((error) {
            debugPrint("🔴 UNEXPECTED CART CLEAR ERROR: $error");
            if (showErrors) {
              showCustomErrorToast(message: Strings.somethingWentWrong);
            }
          });
    }
    await fetchCart(showLoader: false);
    state = state.copyWith(isMutating: false);
  }

  // ? Called on logout — resets cart state.
  void clearSessionCart() {
    state = const CartState(loaderState: LoaderState.noData);
  }

  CartItemModel? _findItemByProductId(int productId) {
    for (final item in state.items) {
      if (item.product.id == productId) return item;
    }
    return null;
  }
}

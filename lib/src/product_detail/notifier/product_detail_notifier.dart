// lib/src/product_detail/notifier/product_detail_notifier.dart
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/providers/cart_providers.dart';
import 'package:medpik/providers/wishlist_providers.dart';
import 'package:medpik/services/repo_di.dart';
import 'package:medpik/src/product_detail/repo/product_detail_repository.dart';
import 'package:medpik/src/product_detail/state/product_detail_state.dart';
import 'package:medpik/utils/common_widgets/custom_toast.dart';
import 'package:medpik/utils/helpers/api_error_handler.dart';
import 'package:medpik/utils/helpers/cart_quantity_helper.dart';

part 'product_detail_notifier.g.dart';

@Riverpod(keepAlive: false)
class ProductDetailNotifier extends _$ProductDetailNotifier {
  late ProductDetailRepo productDetailRepo;
  late final ScrollController scrollController;
  int? _productId;

  @override
  ProductDetailState build() {
    productDetailRepo = ref.read(productDetailRepositoryProvider);
    scrollController = ScrollController();

    ref.onDispose(() {
      scrollController.dispose();
    });

    return const ProductDetailState();
  }

  Future<void> loadProduct(int productId) async {
    if (_productId == productId && state.detail != null) return;
    _productId = productId;

    final wishlistNotifier = ref.read(wishlistNotifierProvider.notifier);
    final isWishlisted = wishlistNotifier.isWishlisted(productId);

    state = state.copyWith(
      loaderState: LoaderState.loading,
      errorMessage: null,
      isWishlisted: isWishlisted,
    );

    return await productDetailRepo
        .getProductById(productId)
        .fold(
          (error) {
            final loaderState = handleResponseError(error.key);
            debugPrint("🔴 PRODUCT ERROR: ${error.message}");
            state = state.copyWith(
              loaderState: loaderState,
              errorMessage: error.message,
            );
          },
          (response) {
            final detail = response.detail;
            if (detail == null) {
              debugPrint("🟡 PRODUCT NO DATA: product_id=$productId");
              state = state.copyWith(loaderState: LoaderState.noData);
              return;
            }
            debugPrint("🟢 PRODUCT SUCCESS: ${detail.product.name}");
            ref
                .read(wishlistNotifierProvider.notifier)
                .syncFromProducts([detail.product]);
            state = state.copyWith(
              loaderState: LoaderState.loaded,
              detail: detail,
              quantity: 1,
              isWishlisted: detail.product.isWishlisted,
            );
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED PRODUCT ERROR: $error");
          state = state.copyWith(loaderState: LoaderState.error);
        });
  }

  Future<void> toggleWishlist() async {
    final product = state.detail?.product;
    if (product == null) return;

    final wishlistNotifier = ref.read(wishlistNotifierProvider.notifier);
    final toggleFuture = wishlistNotifier.toggle(product);
    state = state.copyWith(isWishlisted: wishlistNotifier.isWishlisted(product.id));
    await toggleFuture;
    state = state.copyWith(isWishlisted: wishlistNotifier.isWishlisted(product.id));
  }

  int _cartQuantityFor(int productId) {
    return cartQuantityForProduct(ref.read(cartNotifierProvider).items, productId);
  }

  void incrementQuantity() {
    final productId = state.detail?.product.id;
    if (productId != null && _cartQuantityFor(productId) > 0) {
      ref.read(cartNotifierProvider.notifier).incrementItem(productId);
      debugPrint("🔵 ACTION: cart qty +1 product_id=$productId");
      return;
    }
    state = state.copyWith(quantity: state.quantity + 1);
  }

  void decrementQuantity() {
    final productId = state.detail?.product.id;
    if (productId != null && _cartQuantityFor(productId) > 0) {
      final willRemove = _cartQuantityFor(productId) <= 1;
      ref.read(cartNotifierProvider.notifier).decrementItem(productId);
      if (willRemove) {
        state = state.copyWith(quantity: 1);
      }
      debugPrint("🔵 ACTION: cart qty -1 product_id=$productId");
      return;
    }
    if (state.quantity <= 1) return;
    state = state.copyWith(quantity: state.quantity - 1);
  }

  Future<bool> addToCart() async {
    final product = state.detail?.product;
    if (product == null) return false;

    final cartNotifier = ref.read(cartNotifierProvider.notifier);
    final alreadyInCart = _cartQuantityFor(product.id) > 0;

    if (alreadyInCart) {
      await cartNotifier.incrementItem(product.id);
      showCustomToast(message: Strings.addedToCart, isSuccess: true);
      debugPrint("🔵 ACTION: addToCart increment product_id=${product.id}");
      return true;
    }

    final ok = await cartNotifier.addItem(
      product: product,
      quantity: state.quantity,
    );
    if (ok) {
      showCustomToast(message: Strings.addedToCart, isSuccess: true);
      debugPrint(
        "🔵 ACTION: addToCart product_id=${product.id} qty=${state.quantity}",
      );
    }
    return ok;
  }
}

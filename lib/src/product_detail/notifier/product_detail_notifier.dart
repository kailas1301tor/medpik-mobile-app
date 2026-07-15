// lib/src/product_detail/notifier/product_detail_notifier.dart
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/services/repo_di.dart';
import 'package:tsuite/src/cart/notifier/cart_notifier.dart';
import 'package:tsuite/src/product_detail/model/product_detail_model.dart';
import 'package:tsuite/src/product_detail/repo/product_detail_repository.dart';
import 'package:tsuite/src/product_detail/state/product_detail_state.dart';
import 'package:tsuite/src/wishlist/notifier/wishlist_notifier.dart';
import 'package:tsuite/utils/common_widgets/custom_toast.dart';
import 'package:tsuite/utils/helpers/api_error_handler.dart';

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

    final isWishlisted =
        ref.read(wishlistNotifierProvider.notifier).isWishlisted(productId);

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
            final product = response.product;
            if (product == null) {
              debugPrint("🟡 PRODUCT NO DATA: product_id=$productId");
              state = state.copyWith(loaderState: LoaderState.noData);
              return;
            }
            debugPrint("🟢 PRODUCT SUCCESS: ${product.name}");
            final detail = ProductDetailModel.fromApiProduct(product);
            ref
                .read(wishlistNotifierProvider.notifier)
                .syncFromProducts([product]);
            state = state.copyWith(
              loaderState: LoaderState.loaded,
              detail: detail,
              quantity: 1,
              isWishlisted: product.isWishlisted,
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

    final toggleFuture =
        ref.read(wishlistNotifierProvider.notifier).toggle(product);
    state = state.copyWith(
      isWishlisted: ref
          .read(wishlistNotifierProvider.notifier)
          .isWishlisted(product.id),
    );
    await toggleFuture;
    state = state.copyWith(
      isWishlisted: ref
          .read(wishlistNotifierProvider.notifier)
          .isWishlisted(product.id),
    );
  }

  void incrementQuantity() {
    state = state.copyWith(quantity: state.quantity + 1);
  }

  void decrementQuantity() {
    if (state.quantity <= 1) return;
    state = state.copyWith(quantity: state.quantity - 1);
  }

  Future<bool> addToCart() async {
    final product = state.detail?.product;
    if (product == null) return false;

    ref.read(cartNotifierProvider.notifier).addItem(
          product: product,
          quantity: state.quantity,
        );
    showCustomToast(message: Strings.addedToCart, isSuccess: true);
    return true;
  }
}

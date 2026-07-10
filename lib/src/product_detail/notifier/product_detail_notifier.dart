// lib/src/product_detail/notifier/product_detail_notifier.dart
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/services/repo_di.dart';
import 'package:tsuite/src/cart/notifier/cart_notifier.dart';
import 'package:tsuite/src/product_detail/repo/product_detail_repository.dart';
import 'package:tsuite/src/product_detail/state/product_detail_state.dart';
import 'package:tsuite/utils/common_widgets/custom_toast.dart';
import 'package:tsuite/utils/helpers/api_error_handler.dart';
import 'package:tsuite/res/constants/string_constants.dart';

part 'product_detail_notifier.g.dart';

@Riverpod(keepAlive: false)
class ProductDetailNotifier extends _$ProductDetailNotifier {
  late ProductDetailRepo productDetailRepo;
  int? _productId;

  @override
  ProductDetailState build() {
    productDetailRepo = ref.read(productDetailRepositoryProvider);
    return const ProductDetailState();
  }

  Future<void> loadProduct(int productId) async {
    if (_productId == productId && state.product != null) return;
    _productId = productId;

    state = state.copyWith(loaderState: LoaderState.loading, errorMessage: null);

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
          (product) {
            debugPrint("🟢 PRODUCT SUCCESS: ${product.name}");
            state = state.copyWith(
              loaderState: LoaderState.loaded,
              product: product,
              quantity: 1,
            );
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED PRODUCT ERROR: $error");
          state = state.copyWith(loaderState: LoaderState.error);
        });
  }

  void incrementQuantity() {
    state = state.copyWith(quantity: state.quantity + 1);
  }

  void decrementQuantity() {
    if (state.quantity <= 1) return;
    state = state.copyWith(quantity: state.quantity - 1);
  }

  Future<bool> addToCart() async {
    final product = state.product;
    if (product == null) return false;

    ref.read(cartNotifierProvider.notifier).addItem(
          product: product,
          quantity: state.quantity,
        );
    showCustomToast(message: Strings.addedToCart, isSuccess: true);
    return true;
  }
}

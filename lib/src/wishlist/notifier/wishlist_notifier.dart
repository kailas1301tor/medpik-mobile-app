// lib/src/wishlist/notifier/wishlist_notifier.dart
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/res/constants/app_constants.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/services/repo_di.dart';
import 'package:tsuite/src/wishlist/repo/wishlist_repository.dart';
import 'package:tsuite/src/wishlist/state/wishlist_state.dart';
import 'package:tsuite/utils/common_widgets/custom_toast.dart';
import 'package:tsuite/utils/helpers/api_error_handler.dart';

part 'wishlist_notifier.g.dart';

@Riverpod(keepAlive: true)
class WishlistNotifier extends _$WishlistNotifier {
  late WishlistRepo _wishlistRepo;
  final Set<int> _pendingProductIds = <int>{};

  @override
  WishlistState build() {
    _wishlistRepo = ref.read(wishlistRepositoryProvider);
    return const WishlistState();
  }

  bool isWishlisted(int productId) {
    return state.items.any((item) => item.id == productId);
  }

  Future<void> fetchWishlist() async {
    if (!AppConstants.hasSession) {
      debugPrint('🟡 WISHLIST: skip fetch — no session');
      state = state.copyWith(
        loaderState: state.items.isEmpty ? LoaderState.noData : LoaderState.loaded,
      );
      return;
    }

    state = state.copyWith(loaderState: LoaderState.loading);

    return await _wishlistRepo
        .getWishlist()
        .fold(
          (left) {
            final loaderState = handleResponseError(left.key);
            debugPrint('🔴 WISHLIST ERROR: ${left.message}');
            state = state.copyWith(loaderState: loaderState);
          },
          (right) {
            final products = right.productsDetail;
            debugPrint('🟢 WISHLIST SUCCESS: ${products.length} items');
            state = state.copyWith(
              loaderState:
                  products.isEmpty ? LoaderState.noData : LoaderState.loaded,
              items: products,
            );
          },
        )
        .catchError((e) {
          debugPrint('🔴 UNEXPECTED WISHLIST ERROR: $e');
          state = state.copyWith(loaderState: LoaderState.error);
        });
  }

  void syncFromProducts(List<ProductModel> products) {
    if (products.isEmpty) return;

    final byId = <int, ProductModel>{
      for (final item in state.items) item.id: item,
    };

    for (final product in products) {
      if (product.isWishlisted) {
        byId[product.id] = product.copyWith(isWishlisted: true);
      } else {
        byId.remove(product.id);
      }
    }

    final items = byId.values.toList();
    debugPrint('🟡 WISHLIST: synced from products → ${items.length} items');
    state = state.copyWith(
      items: items,
      loaderState: items.isEmpty ? LoaderState.noData : LoaderState.loaded,
    );
  }

  /// Returns `false` when the user has no session (caller should navigate to login).
  Future<bool> toggle(ProductModel product) async {
    if (!AppConstants.hasSession) {
      debugPrint('🟡 WISHLIST: toggle blocked — no session');
      return false;
    }

    if (_pendingProductIds.contains(product.id)) {
      debugPrint('🟡 WISHLIST: toggle ignored — in flight id=${product.id}');
      return true;
    }

    _pendingProductIds.add(product.id);
    final previousItems = List<ProductModel>.from(state.items);
    final wasWishlisted = isWishlisted(product.id);
    _applyOptimisticToggle(product, wasWishlisted: wasWishlisted);

    try {
      await _wishlistRepo
          .toggleWishlist(productId: product.id)
          .fold(
            (left) {
              debugPrint('🔴 WISHLIST TOGGLE ERROR: ${left.message}');
              state = state.copyWith(
                items: previousItems,
                loaderState: previousItems.isEmpty
                    ? LoaderState.noData
                    : LoaderState.loaded,
              );
              showCustomToast(
                message: (left.message == null || left.message!.trim().isEmpty)
                    ? Strings.wishlistUpdateFailed
                    : left.message!,
                isSuccess: false,
              );
            },
            (right) {
              debugPrint(
                '🟢 WISHLIST TOGGLE SUCCESS: ${right.message} '
                'productId=${product.id}',
              );
            },
          )
          .catchError((e) {
            debugPrint('🔴 UNEXPECTED WISHLIST TOGGLE ERROR: $e');
            state = state.copyWith(
              items: previousItems,
              loaderState: previousItems.isEmpty
                  ? LoaderState.noData
                  : LoaderState.loaded,
            );
            showCustomToast(
              message: Strings.wishlistUpdateFailed,
              isSuccess: false,
            );
          });
    } finally {
      _pendingProductIds.remove(product.id);
    }

    return true;
  }

  void remove(int productId) {
    final items = state.items.where((item) => item.id != productId).toList();
    debugPrint('🟡 WISHLIST: removed productId=$productId');
    state = state.copyWith(
      items: items,
      loaderState: items.isEmpty ? LoaderState.noData : LoaderState.loaded,
    );
  }

  void clear() {
    _pendingProductIds.clear();
    debugPrint('🟡 WISHLIST: cleared');
    state = const WishlistState(loaderState: LoaderState.noData);
  }

  void _applyOptimisticToggle(
    ProductModel product, {
    required bool wasWishlisted,
  }) {
    final items = [...state.items];
    if (wasWishlisted) {
      items.removeWhere((item) => item.id == product.id);
      debugPrint('🟡 WISHLIST: optimistic remove ${product.name}');
    } else {
      items.add(product.copyWith(isWishlisted: true));
      debugPrint('🟢 WISHLIST: optimistic add ${product.name}');
    }
    state = state.copyWith(
      items: items,
      loaderState: items.isEmpty ? LoaderState.noData : LoaderState.loaded,
    );
  }
}

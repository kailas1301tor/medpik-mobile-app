// lib/src/wishlist/notifier/wishlist_notifier.dart
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/data/models/product_model.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/services/repo_di.dart';
import 'package:medpik/src/wishlist/repo/wishlist_repository.dart';
import 'package:medpik/src/wishlist/state/wishlist_state.dart';
import 'package:medpik/utils/common_widgets/custom_toast.dart';
import 'package:medpik/utils/helpers/api_error_handler.dart';

part 'wishlist_notifier.g.dart';

@Riverpod(keepAlive: true)
class WishlistNotifier extends _$WishlistNotifier {
  late WishlistRepo _wishlistRepo;

  @override
  WishlistState build() {
    _wishlistRepo = ref.read(wishlistRepositoryProvider);
    return const WishlistState();
  }

  bool isWishlisted(int productId) {
    return state.items.any((item) => item.id == productId);
  }

  Future<void> fetchWishlist({bool showLoader = true}) async {
    if (showLoader) {
      state = state.copyWith(loaderState: LoaderState.loading);
    }

    return await _wishlistRepo
        .getWishlist()
        .fold(
          (left) {
            final loaderState = loaderStateForSessionAwareError(left.key);
            if (showLoader ||
                state.items.isEmpty ||
                !shouldReportFetchError(left)) {
              state = state.copyWith(loaderState: loaderState);
            }
            if (!shouldReportFetchError(left)) return;
            if (!showLoader && state.items.isNotEmpty) {
              showCustomToast(
                message: (left.message == null || left.message!.trim().isEmpty)
                    ? Strings.somethingWentWrong
                    : left.message!,
                isSuccess: false,
              );
            }
          },
          (right) {
            final products = right.productsDetail;
            state = state.copyWith(
              loaderState: products.isEmpty
                  ? LoaderState.noData
                  : LoaderState.loaded,
              items: products,
            );
          },
        )
        .catchError((e) {
          if (showLoader || state.items.isEmpty) {
            state = state.copyWith(loaderState: LoaderState.error);
          } else {
            showCustomToast(
              message: Strings.somethingWentWrong,
              isSuccess: false,
            );
          }
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
    if (state.pendingToggleIds.contains(product.id)) {
      debugPrint('🟡 WISHLIST: toggle ignored — in flight id=${product.id}');
      return true;
    }

    state = state.copyWith(
      pendingToggleIds: {...state.pendingToggleIds, product.id},
    );

    var sessionMissing = false;

    try {
      await _wishlistRepo
          .toggleWishlist(productId: product.id)
          .fold(
            (left) {
              if (!shouldReportFetchError(left)) {
                sessionMissing = true;
                return;
              }
              showCustomToast(
                message: (left.message == null || left.message!.trim().isEmpty)
                    ? Strings.wishlistUpdateFailed
                    : left.message!,
                isSuccess: false,
              );
            },
            (right) async {
              await fetchWishlist(showLoader: false);
            },
          )
          .catchError((e) {
            showCustomToast(
              message: Strings.wishlistUpdateFailed,
              isSuccess: false,
            );
          });
    } finally {
      final pending = {...state.pendingToggleIds}..remove(product.id);
      state = state.copyWith(pendingToggleIds: pending);
    }

    return !sessionMissing;
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
    debugPrint('🟡 WISHLIST: cleared');
    state = const WishlistState(loaderState: LoaderState.noData);
  }
}

@Riverpod(keepAlive: false)
void wishlistScreenOpened(Ref ref) {
  Future.microtask(() {
    final state = ref.read(wishlistNotifierProvider);
    ref
        .read(wishlistNotifierProvider.notifier)
        .fetchWishlist(showLoader: state.items.isEmpty);
  });
}

@Riverpod(keepAlive: false)
bool isProductWishlisted(Ref ref, int productId) {
  return ref.watch(
    wishlistNotifierProvider.select(
      (s) => s.items.any((item) => item.id == productId),
    ),
  );
}

@Riverpod(keepAlive: false)
bool isWishlistTogglePending(Ref ref, int productId) {
  return ref.watch(
    wishlistNotifierProvider.select(
      (s) => s.pendingToggleIds.contains(productId),
    ),
  );
}

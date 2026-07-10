// lib/src/prescription/notifier/prescription_products_notifier.dart
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/services/repo_di.dart';
import 'package:tsuite/src/home/repo/home_repository.dart';
import 'package:tsuite/src/prescription/state/prescription_products_state.dart';
import 'package:tsuite/src/search/repo/search_repository.dart';
import 'package:tsuite/utils/helpers/api_error_handler.dart';
import 'package:tsuite/utils/helpers/debounce_helper.dart';

part 'prescription_products_notifier.g.dart';

@Riverpod(keepAlive: false)
class PrescriptionProductsNotifier extends _$PrescriptionProductsNotifier {
  static const int _mostBoughtLimit = 9;

  late final TextEditingController searchController;
  late final FocusNode searchFocusNode;
  late final TextEditingController missingProductNameController;
  late final TextEditingController missingProductQuantityController;
  late HomeRepo homeRepo;
  late SearchRepo searchRepo;

  @override
  PrescriptionProductsState build() {
    searchController = TextEditingController();
    searchFocusNode = FocusNode();
    missingProductNameController = TextEditingController();
    missingProductQuantityController = TextEditingController(text: '1');
    homeRepo = ref.read(homeRepositoryProvider);
    searchRepo = ref.read(searchRepositoryProvider);

    ref.onDispose(() {
      searchController.dispose();
      searchFocusNode.dispose();
      missingProductNameController.dispose();
      missingProductQuantityController.dispose();
    });

    Future.microtask(fetchMostBought);
    return const PrescriptionProductsState();
  }

  Future<void> fetchMostBought() async {
    state = state.copyWith(loaderState: LoaderState.loading, errorMessage: null);

    return await homeRepo.getHomeFeed().fold(
      (error) {
        final loaderState = handleResponseError(error.key);
        debugPrint("🔴 MOST BOUGHT ERROR: ${error.message}");
        state = state.copyWith(
          loaderState: loaderState,
          errorMessage: error.message,
        );
      },
      (feed) {
        final products = feed.featuredProducts.take(_mostBoughtLimit).toList();
        debugPrint("🟢 MOST BOUGHT LOADED: ${products.length} items");
        state = state.copyWith(
          loaderState: products.isEmpty ? LoaderState.noData : LoaderState.loaded,
          mostBoughtProducts: products,
        );
      },
    ).catchError((error) {
      debugPrint("🔴 UNEXPECTED MOST BOUGHT ERROR: $error");
      state = state.copyWith(loaderState: LoaderState.error);
    });
  }

  void onSearchChanged(String value) {
    final query = value.trim();
    state = state.copyWith(searchQuery: query);

    if (query.isEmpty) {
      state = state.copyWith(
        hasSearched: false,
        searchResults: [],
        loaderState: state.mostBoughtProducts.isEmpty
            ? LoaderState.noData
            : LoaderState.loaded,
      );
      return;
    }

    debounce(const Duration(milliseconds: 350), () {
      if (state.searchQuery == query) {
        performSearch(query);
      }
    });
  }

  void clearSearch() {
    searchController.clear();
    missingProductNameController.clear();
    missingProductQuantityController.text = '1';
    state = state.copyWith(
      searchQuery: '',
      hasSearched: false,
      searchResults: [],
      loaderState: state.mostBoughtProducts.isEmpty
          ? LoaderState.noData
          : LoaderState.loaded,
    );
  }

  void prepareMissingProductForm(String query) {
    missingProductNameController.text = query;
    missingProductQuantityController.text = '1';
  }

  int parsedMissingProductQuantity() {
    final parsed = int.tryParse(missingProductQuantityController.text.trim());
    if (parsed == null || parsed < 1) return 1;
    return parsed;
  }

  Future<void> performSearch(String query) async {
    state = state.copyWith(
      loaderState: LoaderState.loading,
      searchQuery: query,
      hasSearched: true,
      errorMessage: null,
    );

    return await searchRepo
        .searchProducts(query: query, category: null)
        .fold(
          (error) {
            final loaderState = handleResponseError(error.key);
            debugPrint("🔴 PRESCRIPTION SEARCH ERROR: ${error.message}");
            state = state.copyWith(
              loaderState: loaderState,
              searchResults: [],
              errorMessage: error.message,
            );
          },
          (response) {
            final loaderState = response.products.isEmpty
                ? LoaderState.noData
                : LoaderState.loaded;
            debugPrint(
              "🟢 PRESCRIPTION SEARCH SUCCESS: ${response.products.length} items",
            );
            if (response.products.isEmpty) {
              prepareMissingProductForm(query);
            }
            state = state.copyWith(
              loaderState: loaderState,
              searchResults: response.products,
            );
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED PRESCRIPTION SEARCH ERROR: $error");
          state = state.copyWith(
            loaderState: LoaderState.error,
            searchResults: [],
          );
        });
  }
}

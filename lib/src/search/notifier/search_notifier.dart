// lib/src/search/notifier/search_notifier.dart
import 'dart:async';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/services/repo_di.dart';
import 'package:tsuite/src/home/model/home_model.dart';
import 'package:tsuite/src/prescription/repo/customer_products_repository.dart';
import 'package:tsuite/src/search/model/product_catalog_args.dart';
import 'package:tsuite/src/search/repo/search_repository.dart';
import 'package:tsuite/src/search/state/search_state.dart';
import 'package:tsuite/utils/helpers/api_error_handler.dart';

part 'search_notifier.g.dart';

@Riverpod(keepAlive: false)
class SearchNotifier extends _$SearchNotifier {
  static const int _pageSize = 10;

  late final TextEditingController searchController;
  late final FocusNode searchFocusNode;
  late final TextEditingController catalogSearchController;
  late final FocusNode catalogSearchFocusNode;
  late SearchRepo searchRepo;
  late CustomerProductsRepo customerProductsRepo;

  int _requestId = 0;
  Timer? _debounceTimer;

  @override
  SearchState build() {
    searchController = TextEditingController();
    searchFocusNode = FocusNode();
    catalogSearchController = TextEditingController();
    catalogSearchFocusNode = FocusNode();
    searchRepo = ref.read(searchRepositoryProvider);
    customerProductsRepo = ref.read(customerProductsRepositoryProvider);

    ref.onDispose(() {
      _debounceTimer?.cancel();
      searchController.dispose();
      searchFocusNode.dispose();
      catalogSearchController.dispose();
      catalogSearchFocusNode.dispose();
    });

    Future.microtask(loadInitialData);
    return const SearchState();
  }

  Future<void> loadInitialData() async {
    await searchRepo.getRecentSearches().fold(
      (error) {
        debugPrint("🔴 RECENT SEARCH ERROR: ${error.message}");
      },
      (recent) {
        state = state.copyWith(recentSearches: recent);
      },
    );
  }

  Future<void> initCatalog(ProductCatalogArgs args) async {
    final sameFilters = state.catalogInitialized &&
        state.catalogTitle == args.title &&
        state.query == args.search.trim() &&
        state.categoryId == args.categoryId &&
        state.offerId == args.offerId &&
        (state.loaderState == LoaderState.loaded ||
            state.loaderState == LoaderState.noData);
    if (sameFilters) return;

    catalogSearchController.text = args.search;
    state = state.copyWith(
      catalogTitle: args.title,
      query: args.search.trim(),
      categoryId: args.categoryId,
      offerId: args.offerId,
      catalogInitialized: true,
    );
    await fetchCatalog(page: 1);
  }

  Future<void> fetchCatalog({
    required int page,
    bool append = false,
  }) async {
    final requestId = ++_requestId;
    final search = state.query.trim();
    final categoryId = state.categoryId;
    final offerId = state.offerId;

    if (append) {
      if (!state.hasMore || state.isLoadingMore) return;
      state = state.copyWith(isLoadingMore: true, errorMessage: null);
    } else {
      state = state.copyWith(
        loaderState: LoaderState.loading,
        errorMessage: null,
        results: const [],
        currentPage: 0,
        hasMore: false,
        isLoadingMore: false,
      );
    }

    if (!append && search.isNotEmpty) {
      await searchRepo.saveRecentSearch(search);
    }

    return await customerProductsRepo
        .getCustomerProducts(
          search: search,
          categoryId: categoryId,
          offerId: offerId,
          page: page,
          pageSize: _pageSize,
        )
        .fold(
          (error) {
            if (requestId != _requestId) return;
            final loaderState = handleResponseError(error.key);
            debugPrint("🔴 CATALOG ERROR: ${error.message}");
            state = state.copyWith(
              loaderState: append ? state.loaderState : loaderState,
              isLoadingMore: false,
              errorMessage: error.message,
              results: append ? state.results : const [],
            );
          },
          (response) async {
            if (requestId != _requestId) return;

            if (!append && search.isNotEmpty) {
              await searchRepo.getRecentSearches().fold(
                (left) => null,
                (recent) => state = state.copyWith(recentSearches: recent),
              );
            }

            final pageProducts = response.products;
            final merged = append
                ? [...state.results, ...pageProducts]
                : pageProducts;
            final hasMore = pageProducts.isEmpty
                ? false
                : response.hasMore;

            debugPrint(
              "🟢 CATALOG page=${response.currentPage}: "
              "${pageProducts.length} items (total=${merged.length})",
            );
            state = state.copyWith(
              loaderState:
                  merged.isEmpty ? LoaderState.noData : LoaderState.loaded,
              results: merged,
              currentPage: response.currentPage > 0 ? response.currentPage : page,
              hasMore: hasMore,
              isLoadingMore: false,
            );
          },
        )
        .catchError((error) {
          if (requestId != _requestId) return;
          debugPrint("🔴 UNEXPECTED CATALOG ERROR: $error");
          state = state.copyWith(
            loaderState: append ? state.loaderState : LoaderState.error,
            isLoadingMore: false,
            results: append ? state.results : const [],
          );
        });
  }

  Future<void> refreshCatalog() => fetchCatalog(page: 1);

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) return;
    await fetchCatalog(page: state.currentPage + 1, append: true);
  }

  /// Landing search field — updates local query only (no catalog fetch).
  void onSearchChanged(String value) {
    state = state.copyWith(query: value.trim());
  }

  /// Results search field — debounced catalog refetch.
  void onCatalogSearchChanged(String value) {
    final query = value.trim();
    state = state.copyWith(query: query);

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 350), () {
      if (state.query != query) return;
      fetchCatalog(page: 1);
    });
  }

  void clearSearch() {
    _debounceTimer?.cancel();
    searchController.clear();
    state = state.copyWith(query: '');
  }

  void clearCatalogSearch() {
    _debounceTimer?.cancel();
    catalogSearchController.clear();
    state = state.copyWith(query: '');
    if (state.catalogInitialized) {
      fetchCatalog(page: 1);
    }
  }

  void selectCategory(CategoryModel? category) {
    state = state.copyWith(
      categoryId: category?.id,
      catalogTitle: category?.name ?? Strings.popularProducts,
    );
    if (state.catalogInitialized) {
      fetchCatalog(page: 1);
    }
  }

  void applyRecentSearch(String query) {
    searchController.text = query;
    state = state.copyWith(query: query.trim());
  }

}

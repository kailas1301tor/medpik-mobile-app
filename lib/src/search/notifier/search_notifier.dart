// lib/src/search/notifier/search_notifier.dart
import 'dart:async';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/data/models/category_model.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/services/repo_di.dart';
import 'package:medpik/data/models/product_catalog_args.dart';
import 'package:medpik/src/search/repo/search_repository.dart';
import 'package:medpik/src/search/state/search_state.dart';
import 'package:medpik/utils/helpers/api_error_handler.dart';

part 'search_notifier.g.dart';

@Riverpod(keepAlive: false)
void searchCatalogInit(Ref ref, ProductCatalogArgs args) {
  Future.microtask(
    () => ref.read(searchNotifierProvider.notifier).initCatalog(args),
  );
}

@Riverpod(keepAlive: false)
class SearchNotifier extends _$SearchNotifier {
  static const int _pageSize = 10;

  late final TextEditingController searchController;
  late final FocusNode searchFocusNode;
  late SearchRepo searchRepo;

  int _requestId = 0;
  Timer? _debounceTimer;

  @override
  SearchState build() {
    searchController = TextEditingController();
    searchFocusNode = FocusNode();
    searchRepo = ref.read(searchRepositoryProvider);

    ref.onDispose(() {
      _debounceTimer?.cancel();
      searchController.dispose();
      searchFocusNode.dispose();
    });

    return const SearchState();
  }

  Future<void> initCatalog(ProductCatalogArgs args) async {
    final sameFilters = state.catalogTitle == args.title &&
        state.query == args.search.trim() &&
        state.categoryId == args.categoryId &&
        state.offerId == args.offerId &&
        (state.loaderState == LoaderState.loaded ||
            state.loaderState == LoaderState.noData ||
            state.loaderState == LoaderState.noSearchData);
    if (sameFilters) return;

    searchController.text = args.search;
    state = state.copyWith(
      catalogTitle: args.title,
      query: args.search.trim(),
      categoryId: args.categoryId,
      offerId: args.offerId,
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
      unawaited(searchRepo.saveRecentSearch(search));
    }

    return await searchRepo
        .getCatalogProducts(
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
            final emptyLoaderState = search.isNotEmpty
                ? LoaderState.noSearchData
                : LoaderState.noData;
            state = state.copyWith(
              loaderState:
                  merged.isEmpty ? emptyLoaderState : LoaderState.loaded,
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

  void onSearchChanged(String value) {
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
    fetchCatalog(page: 1);
  }

  void selectCategory(CategoryModel? category) {
    state = state.copyWith(
      categoryId: category?.id,
      offerId: null,
      catalogTitle: category?.name ?? Strings.popularProducts,
    );
    fetchCatalog(page: 1);
  }
}

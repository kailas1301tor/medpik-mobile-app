// lib/src/prescription/notifier/prescription_products_notifier.dart
import 'dart:async';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/services/repo_di.dart';
import 'package:tsuite/src/prescription/repo/customer_products_repository.dart';
import 'package:tsuite/src/prescription/state/prescription_products_state.dart';
import 'package:tsuite/utils/helpers/api_error_handler.dart';

part 'prescription_products_notifier.g.dart';

@Riverpod(keepAlive: false)
class PrescriptionProductsNotifier extends _$PrescriptionProductsNotifier {
  static const int _pageSize = 10;

  late final TextEditingController searchController;
  late final FocusNode searchFocusNode;
  late final TextEditingController missingProductNameController;
  late final TextEditingController missingProductQuantityController;
  late CustomerProductsRepo customerProductsRepo;

  int _requestId = 0;
  Timer? _debounceTimer;

  @override
  PrescriptionProductsState build() {
    searchController = TextEditingController();
    searchFocusNode = FocusNode();
    missingProductNameController = TextEditingController();
    missingProductQuantityController = TextEditingController(
      text: Strings.defaultQuantityHint,
    );
    customerProductsRepo = ref.read(customerProductsRepositoryProvider);

    ref.onDispose(() {
      _debounceTimer?.cancel();
      searchController.dispose();
      searchFocusNode.dispose();
      missingProductNameController.dispose();
      missingProductQuantityController.dispose();
    });

    Future.microtask(() => fetchProducts(page: 1, search: ''));
    return const PrescriptionProductsState();
  }

  Future<void> fetchProducts({
    required int page,
    required String search,
    bool append = false,
  }) async {
    final requestId = ++_requestId;

    if (append) {
      if (!state.hasMore || state.isLoadingMore) return;
      state = state.copyWith(isLoadingMore: true, errorMessage: null);
    } else {
      state = state.copyWith(
        loaderState: LoaderState.loading,
        errorMessage: null,
        products: const [],
        currentPage: 0,
        totalPages: 0,
        hasMore: false,
        isLoadingMore: false,
        hasSearched: search.trim().isNotEmpty,
        searchQuery: search.trim(),
      );
    }

    return await customerProductsRepo
        .getCustomerProducts(
          search: search.trim(),
          page: page,
          pageSize: _pageSize,
        )
        .fold(
          (error) {
            if (requestId != _requestId) return;
            final loaderState = handleResponseError(error.key);
            debugPrint("🔴 CUSTOMER PRODUCTS ERROR: ${error.message}");
            state = state.copyWith(
              loaderState: append ? state.loaderState : loaderState,
              isLoadingMore: false,
              errorMessage: error.message,
            );
          },
          (response) {
            if (requestId != _requestId) return;
            final merged = append
                ? [...state.products, ...response.products]
                : response.products;
            if (search.trim().isNotEmpty && merged.isEmpty) {
              prepareMissingProductForm(search.trim());
            }
            debugPrint(
              "🟢 CUSTOMER PRODUCTS page=${response.currentPage}: "
              "${response.products.length} items (total=${merged.length})",
            );
            state = state.copyWith(
              loaderState:
                  merged.isEmpty ? LoaderState.noData : LoaderState.loaded,
              products: merged,
              currentPage: response.currentPage,
              totalPages: response.totalPages,
              hasMore: response.hasMore,
              isLoadingMore: false,
              hasSearched: search.trim().isNotEmpty,
              searchQuery: search.trim(),
            );
          },
        )
        .catchError((error) {
          if (requestId != _requestId) return;
          debugPrint("🔴 UNEXPECTED CUSTOMER PRODUCTS ERROR: $error");
          state = state.copyWith(
            loaderState: append ? state.loaderState : LoaderState.error,
            isLoadingMore: false,
          );
        });
  }

  void onSearchChanged(String value) {
    final query = value.trim();
    state = state.copyWith(searchQuery: query);

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 350), () {
      if (state.searchQuery != query) return;
      fetchProducts(page: 1, search: query);
    });
  }

  void clearSearch() {
    _debounceTimer?.cancel();
    searchController.clear();
    missingProductNameController.clear();
    missingProductQuantityController.text = '1';
    state = state.copyWith(
      searchQuery: '',
      hasSearched: false,
    );
    fetchProducts(page: 1, search: '');
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) return;
    await fetchProducts(
      page: state.currentPage + 1,
      search: state.searchQuery,
      append: true,
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
}

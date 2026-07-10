// lib/src/search/notifier/search_notifier.dart
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/services/repo_di.dart';
import 'package:tsuite/src/search/repo/search_repository.dart';
import 'package:tsuite/src/search/state/search_state.dart';
import 'package:tsuite/utils/helpers/api_error_handler.dart';
import 'package:tsuite/utils/helpers/debounce_helper.dart';

part 'search_notifier.g.dart';

@Riverpod(keepAlive: false)
class SearchNotifier extends _$SearchNotifier {
  late final TextEditingController searchController;
  late final FocusNode searchFocusNode;
  late SearchRepo searchRepo;

  @override
  SearchState build() {
    searchController = TextEditingController();
    searchFocusNode = FocusNode();
    searchRepo = ref.read(searchRepositoryProvider);

    ref.onDispose(() {
      searchController.dispose();
      searchFocusNode.dispose();
    });

    Future.microtask(loadInitialData);
    return const SearchState();
  }

  Future<void> initResults(String query) async {
    if (state.query == query &&
        (state.loaderState == LoaderState.loaded ||
            state.loaderState == LoaderState.noData)) {
      return;
    }
    searchController.text = query;
    await performSearch(query: query, category: state.selectedCategory);
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

    await searchRepo
        .searchProducts(query: '', category: null)
        .fold(
          (error) {
            debugPrint("🔴 CATEGORIES ERROR: ${error.message}");
          },
          (response) {
            state = state.copyWith(categories: response.categories);
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED CATEGORIES ERROR: $error");
        });
  }

  void onSearchChanged(String value) {
    state = state.copyWith(query: value.trim());
    debounce(const Duration(milliseconds: 350), () {
      if (state.query == value.trim()) {
        performSearch(query: value.trim(), category: state.selectedCategory);
      }
    });
  }

  void clearSearch() {
    searchController.clear();
    state = state.copyWith(query: '');
  }

  void selectCategory(String? category) {
    state = state.copyWith(
      selectedCategory: category?.isEmpty ?? true ? null : category,
    );
    performSearch(query: state.query, category: state.selectedCategory);
  }

  void applyRecentSearch(String query) {
    searchController.text = query;
    state = state.copyWith(query: query);
    performSearch(query: query, category: state.selectedCategory);
  }

  Future<void> performSearch({
    required String query,
    String? category,
  }) async {
    state = state.copyWith(
      loaderState: LoaderState.loading,
      query: query,
      selectedCategory: category,
      errorMessage: null,
    );

    if (query.isNotEmpty) {
      await searchRepo.saveRecentSearch(query);
    }

    return await searchRepo
        .searchProducts(query: query, category: category)
        .fold(
          (error) {
            final loaderState = handleResponseError(error.key);
            debugPrint("🔴 SEARCH ERROR: ${error.message}");
            state = state.copyWith(
              loaderState: loaderState,
              errorMessage: error.message,
              results: [],
            );
          },
          (response) async {
            if (query.isNotEmpty) {
              await searchRepo.getRecentSearches().fold(
                    (left) => null,
                    (recent) => state = state.copyWith(recentSearches: recent),
                  );
            }

            final loaderState = response.products.isEmpty
                ? LoaderState.noData
                : LoaderState.loaded;
            debugPrint("🟢 SEARCH SUCCESS: ${response.products.length} items");
            state = state.copyWith(
              loaderState: loaderState,
              results: response.products,
              categories: response.categories,
            );
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED SEARCH ERROR: $error");
          state = state.copyWith(loaderState: LoaderState.error, results: []);
        });
  }
}

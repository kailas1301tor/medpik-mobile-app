// lib/src/search/state/search_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medpik/data/models/product_model.dart';
import 'package:medpik/res/enums/enums.dart';

part 'search_state.freezed.dart';

@freezed
sealed class SearchState with _$SearchState {
  const factory SearchState({
    @Default(LoaderState.loaded) LoaderState loaderState,
    @Default('') String query,
    @Default('') String catalogTitle,
    int? categoryId,
    int? offerId,
    @Default(0) int currentPage,
    @Default(false) bool hasMore,
    @Default(false) bool isLoadingMore,
    @Default(false) bool catalogInitialized,
    @Default([]) List<String> recentSearches,
    @Default([]) List<ProductModel> results,
    String? errorMessage,
  }) = _SearchState;
}

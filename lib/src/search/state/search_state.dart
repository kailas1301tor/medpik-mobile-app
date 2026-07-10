// lib/src/search/state/search_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/src/home/model/home_model.dart';

part 'search_state.freezed.dart';

@freezed
sealed class SearchState with _$SearchState {
  const factory SearchState({
    @Default(LoaderState.loaded) LoaderState loaderState,
    @Default('') String query,
    String? selectedCategory,
    @Default([]) List<String> recentSearches,
    @Default([]) List<CategoryModel> categories,
    @Default([]) List<ProductModel> results,
    String? errorMessage,
  }) = _SearchState;
}

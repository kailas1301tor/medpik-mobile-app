// lib/src/prescription/state/prescription_products_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/res/enums/enums.dart';

part 'prescription_products_state.freezed.dart';

@freezed
sealed class PrescriptionProductsState with _$PrescriptionProductsState {
  const factory PrescriptionProductsState({
    @Default(LoaderState.loading) LoaderState loaderState,
    @Default(<ProductModel>[]) List<ProductModel> mostBoughtProducts,
    @Default(<ProductModel>[]) List<ProductModel> searchResults,
    @Default('') String searchQuery,
    @Default(false) bool hasSearched,
    String? errorMessage,
  }) = _PrescriptionProductsState;
}

// lib/src/prescription/state/prescription_products_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medpik/data/models/product_model.dart';
import 'package:medpik/res/enums/enums.dart';

part 'prescription_products_state.freezed.dart';

@freezed
sealed class PrescriptionProductsState with _$PrescriptionProductsState {
  const factory PrescriptionProductsState({
    @Default(LoaderState.loading) LoaderState loaderState,
    @Default(<ProductModel>[]) List<ProductModel> products,
    @Default('') String searchQuery,
    @Default(false) bool hasSearched,
    @Default(1) int currentPage,
    @Default(1) int totalPages,
    @Default(false) bool hasMore,
    @Default(false) bool isLoadingMore,
    String? errorMessage,
  }) = _PrescriptionProductsState;
}

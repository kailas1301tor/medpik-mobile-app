// lib/src/product_detail/state/product_detail_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/res/enums/enums.dart';

part 'product_detail_state.freezed.dart';

@freezed
sealed class ProductDetailState with _$ProductDetailState {
  const factory ProductDetailState({
    @Default(LoaderState.loaded) LoaderState loaderState,
    ProductModel? product,
    @Default(1) int quantity,
    String? errorMessage,
  }) = _ProductDetailState;
}

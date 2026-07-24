// lib/src/product_detail/state/product_detail_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/src/product_detail/model/product_detail_model.dart';

part 'product_detail_state.freezed.dart';

@freezed
sealed class ProductDetailState with _$ProductDetailState {
  const factory ProductDetailState({
    @Default(LoaderState.loaded) LoaderState loaderState,
    ProductDetailModel? detail,
    @Default(1) int quantity,
    @Default(false) bool isWishlisted,
    String? errorMessage,
  }) = _ProductDetailState;
}

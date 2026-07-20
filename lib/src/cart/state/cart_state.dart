// lib/src/cart/state/cart_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/src/cart/model/cart_item_model.dart';

part 'cart_state.freezed.dart';

@freezed
sealed class CartState with _$CartState {
  const factory CartState({
    @Default(LoaderState.loaded) LoaderState loaderState,
    @Default([]) List<CartItemModel> items,
    @Default(false) bool isMutating,
  }) = _CartState;
}

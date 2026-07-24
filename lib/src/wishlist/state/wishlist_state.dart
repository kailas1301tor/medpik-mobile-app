// lib/src/wishlist/state/wishlist_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medpik/data/models/product_model.dart';
import 'package:medpik/res/enums/enums.dart';

part 'wishlist_state.freezed.dart';

@freezed
sealed class WishlistState with _$WishlistState {
  const factory WishlistState({
    @Default(LoaderState.noData) LoaderState loaderState,
    @Default([]) List<ProductModel> items,
  }) = _WishlistState;
}

// lib/src/wishlist/state/wishlist_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/res/enums/enums.dart';

part 'wishlist_state.freezed.dart';

@freezed
sealed class WishlistState with _$WishlistState {
  const factory WishlistState({
    @Default(LoaderState.loaded) LoaderState loaderState,
    @Default([]) List<ProductModel> items,
  }) = _WishlistState;
}

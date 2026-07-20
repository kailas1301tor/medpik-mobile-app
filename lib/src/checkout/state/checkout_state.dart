// lib/src/checkout/state/checkout_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tsuite/data/models/address_model.dart';
import 'package:tsuite/res/enums/enums.dart';

part 'checkout_state.freezed.dart';

@freezed
sealed class CheckoutState with _$CheckoutState {
  const factory CheckoutState({
    @Default(LoaderState.loaded) LoaderState loaderState,
    AddressModel? selectedAddress,
    @Default('') String pharmacistInstructions,
    @Default(0) double payableTotal,
    @Default(false) bool isPlacingOrder,
    String? errorMessage,
    String? placedOrderId,
  }) = _CheckoutState;
}

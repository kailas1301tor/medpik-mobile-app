// lib/src/checkout/state/checkout_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medpik/data/models/address_model.dart';
import 'package:medpik/res/enums/enums.dart';

part 'checkout_state.freezed.dart';

@freezed
sealed class CheckoutState with _$CheckoutState {
  const factory CheckoutState({
    @Default(LoaderState.loaded) LoaderState loaderState,
    AddressModel? selectedAddress,
    @Default('') String pharmacistInstructions,
    @Default(false) bool isPlacingOrder,
    String? errorMessage,
  }) = _CheckoutState;
}

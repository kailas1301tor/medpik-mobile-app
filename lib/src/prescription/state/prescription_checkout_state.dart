// lib/src/prescription/state/prescription_checkout_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medpik/data/models/address_model.dart';
import 'package:medpik/res/enums/enums.dart';

part 'prescription_checkout_state.freezed.dart';

@freezed
sealed class PrescriptionCheckoutState with _$PrescriptionCheckoutState {
  const factory PrescriptionCheckoutState({
    @Default(LoaderState.loaded) LoaderState loaderState,
    AddressModel? selectedAddress,
    @Default(false) bool isPlacingOrder,
    String? errorMessage,
    String? placedOrderId,
  }) = _PrescriptionCheckoutState;
}

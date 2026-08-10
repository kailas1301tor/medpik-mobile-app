// lib/src/address/state/address_state.dart
//
// ? Immutable UI state for AddressNotifier.
//
// ? List screen:
// ? - loaderState / addresses → AddressBookScreen (CommonSwitchState)
// ? - isDeletingAddress → delete confirmation dialog button loader
//
// ? Form sheet:
// ? - isSaving → disables form + PrimaryButton loader
// ? - isDefaultSelected → default toggle (AddressFormFields)
// ? - pickedLocationSummary → map pick preview (AddressFormMapPickRow)
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medpik/data/models/address_model.dart';
import 'package:medpik/res/enums/enums.dart';

part 'address_state.freezed.dart';

@freezed
sealed class AddressState with _$AddressState {
  const factory AddressState({
    @Default(LoaderState.loaded) LoaderState loaderState,
    @Default([]) List<AddressModel> addresses,
    @Default(false) bool isSaving,
    @Default(false) bool isDefaultSelected,
    @Default(false) bool isDeletingAddress,
    String? errorMessage,
    @Default('') String pickedLocationSummary,
  }) = _AddressState;
}

// lib/src/address/state/address_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tsuite/data/models/address_model.dart';
import 'package:tsuite/res/enums/enums.dart';

part 'address_state.freezed.dart';

@freezed
sealed class AddressState with _$AddressState {
  const factory AddressState({
    @Default(LoaderState.loaded) LoaderState loaderState,
    @Default([]) List<AddressModel> addresses,
    @Default(false) bool isSaving,
    String? errorMessage,
  }) = _AddressState;
}


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

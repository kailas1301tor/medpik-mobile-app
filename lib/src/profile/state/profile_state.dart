// lib/src/profile/state/profile_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/src/profile/model/profile_model.dart';

part 'profile_state.freezed.dart';

@freezed
sealed class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(LoaderState.loaded) LoaderState loaderState,
    ProfileModel? profile,
    @Default(false) bool isSaving,
    @Default(false) bool isProfileFormValid,
    String? firstNameError,
    String? lastNameError,
  }) = _ProfileState;
}

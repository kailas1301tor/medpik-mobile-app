// lib/src/auth/state/auth_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/src/auth/model/auth_model.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState({
    @Default(LoaderState.loaded) LoaderState loaderState,
    String? phoneErrorText,
    @Default(false) bool isPhoneValid,
    String? selectedGender,
    String? profilePhotoUrl,
    String? registerErrorText,
    @Default(0) int resendCountdown,
    AuthModel? authModel,
    String? errorMessage,
  }) = _AuthState;
}

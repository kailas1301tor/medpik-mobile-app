// lib/src/auth/state/auth_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medpik/src/auth/model/auth_model.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState({
    AuthModel? authModel,
    String? otpPhone,
    String? phoneErrorText,
    String? otpErrorMessage,
    @Default(false) bool isPhoneValid,
    @Default(false) bool isOtpValid,
    @Default(false) bool isRequestingOtp,
    @Default(false) bool isResendingOtp,
    @Default(false) bool isVerifyingOtp,
    @Default(false) bool isSigningOut,
    @Default(0) int resendCountdown,
  }) = _AuthState;
}

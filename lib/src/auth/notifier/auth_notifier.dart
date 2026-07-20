// lib/src/auth/notifier/auth_notifier.dart
import 'dart:async';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/res/constants/app_constants.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/services/auth_session_service.dart';
import 'package:tsuite/services/repo_di.dart';
import 'package:tsuite/src/auth/repo/auth_repo.dart';
import 'package:tsuite/src/auth/state/auth_state.dart';
import 'package:tsuite/src/cart/notifier/cart_notifier.dart';
import 'package:tsuite/services/wishlist_facade_service.dart';
import 'package:tsuite/utils/common_widgets/custom_toast.dart';
import 'package:tsuite/utils/helpers/api_error_handler.dart';
import 'package:tsuite/utils/helpers/validators.dart';

part 'auth_notifier.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  late final TextEditingController phoneController;

  late AuthRepo authRepo;
  Timer? _resendTimer;

  @override
  AuthState build() {
    phoneController = TextEditingController();
    authRepo = ref.read(authRepositoryProvider);
    phoneController.addListener(_onPhoneChanged);

    ref.onDispose(() {
      _resendTimer?.cancel();
      phoneController.removeListener(_onPhoneChanged);
      phoneController.dispose();
    });

    return const AuthState();
  }

  void _onPhoneChanged() {
    final text = phoneController.text.trim();
    final isValid = Validators.validatePhone(text) == null;
    if (state.isPhoneValid != isValid) {
      state = state.copyWith(isPhoneValid: isValid);
    }
  }

  bool validatePhoneField() {
    final phoneError = Validators.validatePhone(phoneController.text);
    state = state.copyWith(phoneErrorText: phoneError);
    return phoneError == null;
  }

  void clearPhoneError() {
    state = state.copyWith(phoneErrorText: null);
  }

  void _toastError(String? message) {
    showCustomToast(
      message: (message == null || message.trim().isEmpty)
          ? Strings.somethingWentWrong
          : message,
      isSuccess: false,
    );
  }

  void _toastSuccess(String? message, {String fallback = ''}) {
    final text = (message == null || message.trim().isEmpty)
        ? fallback
        : message;
    if (text.isEmpty) return;
    showCustomToast(message: text, isSuccess: true);
  }

  Future<void> restoreSessionToState() async {
    final session = await ref.read(authSessionServiceProvider).restore();
    if (session == null) {
      state = const AuthState();
      return;
    }
    state = state.copyWith(
      authModel: session.authModel,
      isNewUser: session.isNewUser,
      loaderState: LoaderState.loaded,
    );
    debugPrint('🟢 AUTH: session restored to state');
  }

  Future<bool> requestOtp() async {
    if (!validatePhoneField()) {
      return false;
    }

    state = state.copyWith(loaderState: LoaderState.loading);
    final phone = phoneController.text.trim();

    return await authRepo
        .requestOtp(
          phone: phone,
          countryCode: AppConstants.defaultCountryCode,
        )
        .fold(
          (error) {
            final loaderState = handleResponseError(error.key);
            debugPrint('🔴 REQUEST OTP ERROR: ${error.message}');
            state = state.copyWith(loaderState: loaderState);
            _toastError(error.message);
            return false;
          },
          (response) {
            debugPrint('🟢 REQUEST OTP SUCCESS: ${response.message}');
            state = state.copyWith(loaderState: LoaderState.loaded);
            _toastSuccess(
              response.message,
              fallback: Strings.otpSentSuccess,
            );
            startResendTimer();
            return true;
          },
        )
        .catchError((error) {
          debugPrint('🔴 UNEXPECTED REQUEST OTP ERROR: $error');
          state = state.copyWith(loaderState: LoaderState.error);
          _toastError(Strings.somethingWentWrong);
          return false;
        });
  }

  Future<bool> resendOtp() async {
    final phone = phoneController.text.trim();
    state = state.copyWith(loaderState: LoaderState.loading);

    return await authRepo
        .resendOtp(
          phone: phone,
          countryCode: AppConstants.defaultCountryCode,
        )
        .fold(
          (error) {
            final loaderState = handleResponseError(error.key);
            debugPrint('🔴 RESEND OTP ERROR: ${error.message}');
            state = state.copyWith(loaderState: loaderState);
            _toastError(error.message);
            return false;
          },
          (response) {
            debugPrint('🟢 RESEND OTP SUCCESS: ${response.message}');
            state = state.copyWith(loaderState: LoaderState.loaded);
            _toastSuccess(
              response.message,
              fallback: Strings.otpSentSuccess,
            );
            startResendTimer();
            return true;
          },
        )
        .catchError((error) {
          debugPrint('🔴 UNEXPECTED RESEND OTP ERROR: $error');
          state = state.copyWith(loaderState: LoaderState.error);
          _toastError(Strings.somethingWentWrong);
          return false;
        });
  }

  Future<bool> verifyOtpCode(String code) async {
    state = state.copyWith(loaderState: LoaderState.loading);
    final phone = phoneController.text.trim();

    return await authRepo
        .verifyOtp(
          phone: phone,
          otp: code,
          countryCode: AppConstants.defaultCountryCode,
        )
        .fold(
          (error) {
            final loaderState = handleResponseError(error.key);
            debugPrint('🔴 VERIFY OTP ERROR: ${error.message}');
            state = state.copyWith(loaderState: loaderState);
            _toastError(error.message ?? Strings.otpVerificationFailed);
            return false;
          },
          (result) async {
            if (!result.verified) {
              debugPrint('🔴 VERIFY OTP: verified=false');
              state = state.copyWith(loaderState: LoaderState.error);
              _toastError(Strings.otpVerificationFailed);
              return false;
            }

            if (result.authModel.isSuspended) {
              debugPrint('🔴 ACCOUNT SUSPENDED: ${result.authModel.phone}');
              state = state.copyWith(loaderState: LoaderState.error);
              _toastError(Strings.accountSuspended);
              return false;
            }

            final authModel =
                await ref.read(authSessionServiceProvider).save(result);
            debugPrint(
              '🟢 VERIFY OTP SUCCESS: phone=${authModel.phone} '
              'isNewUser=${result.isNewUser}',
            );
            state = state.copyWith(
              loaderState: LoaderState.loaded,
              authModel: authModel,
              isNewUser: result.isNewUser,
            );
            _toastSuccess(
              result.message,
              fallback: Strings.otpVerifiedSuccess,
            );
            await ref.read(wishlistFacadeServiceProvider).fetchWishlist();
            return true;
          },
        )
        .catchError((error) {
          debugPrint('🔴 UNEXPECTED VERIFY OTP ERROR: $error');
          state = state.copyWith(loaderState: LoaderState.error);
          _toastError(Strings.somethingWentWrong);
          return false;
        });
  }

  void startResendTimer() {
    _resendTimer?.cancel();
    state = state.copyWith(resendCountdown: AppConstants.otpResendDuration);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.resendCountdown <= 1) {
        timer.cancel();
        state = state.copyWith(resendCountdown: 0);
      } else {
        state = state.copyWith(resendCountdown: state.resendCountdown - 1);
      }
    });
  }

  Future<void> signOut() async {
    await authRepo.logout().fold(
          (error) {
            debugPrint('🔴 LOGOUT API ERROR: ${error.message}');
          },
          (response) {
            debugPrint('🟢 LOGOUT API SUCCESS: ${response.message}');
          },
        );

    await ref.read(authSessionServiceProvider).clear();
    ref.read(wishlistFacadeServiceProvider).clear();
    ref.read(cartNotifierProvider.notifier).clearSessionCart();
    state = const AuthState();
    phoneController.clear();
    showCustomToast(message: Strings.signedOut, isSuccess: true);
  }
}

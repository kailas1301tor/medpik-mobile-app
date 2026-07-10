// lib/src/auth/notifier/auth_notifier.dart
import 'dart:async';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/res/constants/app_constants.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/services/repo_di.dart';
import 'package:tsuite/services/token_service.dart';
import 'package:tsuite/src/auth/model/auth_model.dart';
import 'package:tsuite/src/auth/repo/auth_repo.dart';
import 'package:tsuite/src/auth/state/auth_state.dart';
import 'package:tsuite/utils/common_widgets/custom_toast.dart';
import 'package:tsuite/utils/helpers/api_error_handler.dart';
import 'package:tsuite/utils/helpers/validators.dart';

part 'auth_notifier.g.dart';

@Riverpod(keepAlive: false)
class AuthNotifier extends _$AuthNotifier {
  late final TextEditingController phoneController;
  late final TextEditingController fullNameController;
  late final TextEditingController registerPhoneController;
  late final TextEditingController ageController;
  late final TextEditingController addressController;

  late AuthRepo authRepo;
  Timer? _resendTimer;

  @override
  AuthState build() {
    phoneController = TextEditingController();
    fullNameController = TextEditingController();
    registerPhoneController = TextEditingController();
    ageController = TextEditingController();
    addressController = TextEditingController();

    authRepo = ref.read(authRepositoryProvider);

    phoneController.addListener(_onPhoneChanged);

    ref.onDispose(() {
      _resendTimer?.cancel();
      phoneController.removeListener(_onPhoneChanged);
      phoneController.dispose();
      fullNameController.dispose();
      registerPhoneController.dispose();
      ageController.dispose();
      addressController.dispose();
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

  Future<bool> requestOtp() async {
    if (!validatePhoneField()) {
      return false;
    }

    state = state.copyWith(loaderState: LoaderState.loading, errorMessage: null);
    final phone = phoneController.text.trim();

    return await authRepo
        .requestOtp(phone: phone)
        .fold(
          (error) {
            final loaderState = handleResponseError(error.key);
            debugPrint("🔴 REQUEST OTP ERROR: ${error.message}");
            state = state.copyWith(
              loaderState: loaderState,
              errorMessage: error.message,
            );
            showCustomToast(
              message: error.message ?? Strings.otpVerificationFailed,
              isSuccess: false,
            );
            return false;
          },
          (response) {
            debugPrint("🟢 REQUEST OTP SUCCESS: ${response.message}");
            state = state.copyWith(loaderState: LoaderState.loaded);
            showCustomToast(message: response.message, isSuccess: true);
            startResendTimer();
            return true;
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED REQUEST OTP ERROR: $error");
          state = state.copyWith(loaderState: LoaderState.error);
          return false;
        });
  }

  Future<bool> resendOtp() async {
    final phone = phoneController.text.trim();
    state = state.copyWith(loaderState: LoaderState.loading);

    return await authRepo
        .resendOtp(phone: phone)
        .fold(
          (error) {
            final loaderState = handleResponseError(error.key);
            debugPrint("🔴 RESEND OTP ERROR: ${error.message}");
            state = state.copyWith(loaderState: loaderState);
            showCustomToast(
              message: error.message ?? Strings.otpVerificationFailed,
              isSuccess: false,
            );
            return false;
          },
          (response) {
            debugPrint("🟢 RESEND OTP SUCCESS: ${response.message}");
            state = state.copyWith(loaderState: LoaderState.loaded);
            showCustomToast(message: response.message, isSuccess: true);
            startResendTimer();
            return true;
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED RESEND OTP ERROR: $error");
          state = state.copyWith(loaderState: LoaderState.error);
          return false;
        });
  }

  Future<bool> verifyOtpCode(String code) async {
    state = state.copyWith(loaderState: LoaderState.loading, errorMessage: null);
    final phone = phoneController.text.trim();

    return await authRepo
        .verifyOtp(phone: phone, otp: code)
        .fold(
          (error) {
            final loaderState = handleResponseError(error.key);
            debugPrint("🔴 VERIFY OTP ERROR: ${error.message}");
            state = state.copyWith(
              loaderState: loaderState,
              errorMessage: error.message,
            );
            showCustomToast(
              message: error.message ?? Strings.otpVerificationFailed,
              isSuccess: false,
            );
            return false;
          },
          (authModel) async {
            if (authModel.isSuspended) {
              debugPrint("🔴 ACCOUNT SUSPENDED: ${authModel.phone}");
              state = state.copyWith(
                loaderState: LoaderState.error,
                errorMessage: Strings.accountSuspended,
              );
              showCustomToast(
                message: Strings.accountSuspended,
                isSuccess: false,
              );
              return false;
            }

            await ref.read(tokenServiceProvider).saveTokens(
                  accessToken: authModel.accessToken ?? '',
                  refreshToken: authModel.refreshToken ?? '',
                );
            debugPrint("🟢 VERIFY OTP SUCCESS: ${authModel.name}");
            state = state.copyWith(
              loaderState: LoaderState.loaded,
              authModel: authModel,
            );
            return true;
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED VERIFY OTP ERROR: $error");
          state = state.copyWith(loaderState: LoaderState.error);
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

  void setGender(String? gender) {
    state = state.copyWith(selectedGender: gender);
  }

  void setProfilePhoto(String? path) {
    state = state.copyWith(profilePhotoUrl: path);
  }

  Future<bool> registerUser() async {
    state = state.copyWith(
      loaderState: LoaderState.loading,
      registerErrorText: null,
    );

    await Future.delayed(const Duration(seconds: 1));

    final name = fullNameController.text.trim();
    final phone = registerPhoneController.text.trim();
    final age = ageController.text.trim();
    final address = addressController.text.trim();

    if (name.isEmpty ||
        phone.isEmpty ||
        age.isEmpty ||
        address.isEmpty ||
        state.selectedGender == null) {
      state = state.copyWith(
        loaderState: LoaderState.loaded,
        registerErrorText: Strings.fieldRequired,
      );
      showCustomToast(
        message: Strings.fieldRequired,
        isSuccess: false,
      );
      return false;
    }

    await ref.read(tokenServiceProvider).saveTokens(
          accessToken: 'mock_access_token',
          refreshToken: 'mock_refresh_token',
        );

    state = state.copyWith(
      loaderState: LoaderState.loaded,
      authModel: AuthModel(
        id: 2,
        email: '$name@medpik.com',
        name: name,
        phone: phone,
        accessToken: 'mock_access_token',
        refreshToken: 'mock_refresh_token',
      ),
    );

    showCustomToast(message: 'Registration successful!', isSuccess: true);
    return true;
  }

  Future<void> signOut() async {
    await authRepo.logout().fold(
          (error) {
            debugPrint("🔴 LOGOUT ERROR: ${error.message}");
          },
          (_) async {
            await ref.read(tokenServiceProvider).clearTokens();
            debugPrint("🟢 SIGNED OUT");
          },
        );
    state = const AuthState();
    showCustomToast(message: Strings.signedOut, isSuccess: true);
  }
}

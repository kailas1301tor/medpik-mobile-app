// lib/src/auth/notifier/auth_notifier.dart
import 'dart:async';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/data/local/sembast_services.dart';
import 'package:medpik/data/models/personal_information_args.dart';
import 'package:medpik/data/remote/network_services.dart';
import 'package:medpik/providers/cart_providers.dart';
import 'package:medpik/providers/wishlist_providers.dart';
import 'package:medpik/res/constants/app_constants.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/services/invalidate_di.dart';
import 'package:medpik/services/onesignal_service.dart';
import 'package:medpik/services/repo_di.dart';
import 'package:medpik/src/auth/model/auth_model.dart';
import 'package:medpik/src/auth/state/auth_state.dart';
import 'package:medpik/utils/helpers/api_error_handler.dart';
import 'package:medpik/utils/helpers/otp_resend_guard.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';
import 'package:medpik/utils/helpers/toast_helper.dart';
import 'package:medpik/utils/helpers/validators.dart';

import '../../../utils/routes/route_constants.dart';

part 'auth_notifier.g.dart';

@Riverpod(keepAlive: false)
class AuthNotifier extends _$AuthNotifier {
  late final TextEditingController phoneController;
  late final TextEditingController otpController;

  Timer? _resendTimer;

  @override
  AuthState build() {
    phoneController = TextEditingController();
    otpController = TextEditingController();

    phoneController.addListener(_onPhoneChanged);
    otpController.addListener(_onOtpChanged);

    ref.onDispose(() {
      phoneController.removeListener(_onPhoneChanged);
      otpController.removeListener(_onOtpChanged);
      _cancelResendTimer();
      phoneController.dispose();
      otpController.dispose();
    });

    return const AuthState();
  }

  void _onPhoneChanged() {
    final isValid =
        Validators.validatePhone(phoneController.text.trim()) == null;
    if (isValid == state.isPhoneValid && state.phoneErrorText == null) return;
    state = state.copyWith(isPhoneValid: isValid, phoneErrorText: null);
  }

  void _onOtpChanged() {
    final isValid = otpController.text.trim().length == AppConstants.otpLength;
    if (isValid == state.isOtpValid && state.otpErrorMessage == null) return;
    state = state.copyWith(isOtpValid: isValid, otpErrorMessage: null);
  }

  void onOtpCompleted(BuildContext context) {
    if (state.isVerifyingOtp || state.isResendingOtp || state.isRequestingOtp) {
      return;
    }
    if (otpController.text.trim().length != AppConstants.otpLength) return;
    verifyOtp(context);
  }

  Future<String?> bootstrap() async {
    await ref.read(sembastServicesProvider).initialize();
    final authModel = await _restoreSession();
    if (authModel == null) return null;
    state = state.copyWith(authModel: authModel);
    return authModel.id.toString();
  }

  Future<void> requestOtp(BuildContext context) async {
    final phone = phoneController.text.trim();
    final phoneError = Validators.validatePhone(phone);
    if (phoneError != null) {
      state = state.copyWith(phoneErrorText: phoneError, isPhoneValid: false);
      return;
    }
    state = state.copyWith(isRequestingOtp: true, phoneErrorText: null);
    await ref
        .read(authRepositoryProvider)
        .requestOtp(phone: phone, countryCode: AppConstants.defaultCountryCode)
        .fold(
          (left) {
            debugPrint('🔴 API ERROR: ${left.message}');
            state = state.copyWith(isRequestingOtp: false);
            _toastError(
              resolveApiErrorMessage(
                error: left,
                fallback: Strings.somethingWentWrong,
              ),
            );
          },
          (right) async {
            debugPrint('🟢 API SUCCESS: ${right.message}');
            otpController.clear();
            state = state.copyWith(
              otpPhone: phone,
              otpErrorMessage: null,
              isOtpValid: false,
            );
            await startResendTimer();
            state = state.copyWith(isRequestingOtp: false);
            if (!context.mounted) return;
            Navigator.pushNamed(context, RouteConstants.routeOtpScreen);
            _toastSuccess(right.message, fallback: Strings.otpSentSuccess);
          },
        )
        .catchError((error) {
          debugPrint('🔴 UNEXPECTED ERROR: $error');
          _toastError(Strings.somethingWentWrong);
          state = state.copyWith(isRequestingOtp: false);
        });
  }

  Future<void> resendOtp() async {
    final phone = state.otpPhone?.trim() ?? '';
    if (!canResendOtp(
      phone: phone,
      isResendingOtp: state.isResendingOtp,
      isRequestingOtp: state.isRequestingOtp,
      isVerifyingOtp: state.isVerifyingOtp,
      resendCountdown: state.resendCountdown,
    )) {
      return;
    }

    state = state.copyWith(isResendingOtp: true);

    await ref
        .read(authRepositoryProvider)
        .resendOtp(phone: phone, countryCode: AppConstants.defaultCountryCode)
        .fold(
          (left) {
            debugPrint('🔴 API ERROR: ${left.message}');
            _toastError(
              resolveApiErrorMessage(
                error: left,
                fallback: Strings.somethingWentWrong,
              ),
            );
          },
          (right) async {
            debugPrint('🟢 API SUCCESS: ${right.message}');
            otpController.clear();
            await startResendTimer();
            state = state.copyWith(
              otpErrorMessage: null,
              isOtpValid: false,
            );
            _toastSuccess(right.message, fallback: Strings.otpSentSuccess);
          },
        )
        .catchError((error) {
          debugPrint('🔴 UNEXPECTED ERROR: $error');
          _toastError(Strings.somethingWentWrong);
        });

    state = state.copyWith(isResendingOtp: false);
  }

  Future<void> verifyOtp(BuildContext context) async {
    final phone = state.otpPhone?.trim() ?? '';
    final otp = otpController.text.trim();
    if (phone.isEmpty ||
        state.isVerifyingOtp ||
        state.isResendingOtp ||
        state.isRequestingOtp ||
        otp.length != AppConstants.otpLength) {
      return;
    }

    state = state.copyWith(isVerifyingOtp: true, otpErrorMessage: null);

    await ref
        .read(authRepositoryProvider)
        .verifyOtp(
          phone: phone,
          otp: otp,
          countryCode: AppConstants.defaultCountryCode,
        )
        .fold(
          (left) {
            debugPrint('🔴 API ERROR: ${left.message}');
            final message = resolveApiErrorMessage(
              error: left,
              fallback: Strings.otpVerificationFailed,
            );
            state = state.copyWith(
              otpErrorMessage: message,
              isVerifyingOtp: false,
            );
            _toastError(message);
          },
          (right) async {
            final error = right.validationError;
            if (error != null) {
              debugPrint('🔴 VERIFY OTP: $error');
              state = state.copyWith(
                otpErrorMessage: error,
                isVerifyingOtp: false,
              );
              _toastError(error);
              return;
            }

            final authModel = right.authModel!;
            debugPrint(
              '🟢 VERIFY OTP: isNewUser=${right.isNewUser} verified=${right.verified}',
            );
            final saved = await _saveSession(
              authModel: authModel,
              isNewUser: right.isNewUser,
            );

            await _syncAfterLogin();
            if (context.mounted) {
              final destination = right.isNewUser
                  ? RouteConstants.routePersonalInformationScreen
                  : RouteConstants.mainScreen;

              Navigator.pushNamedAndRemoveUntil(
                context,
                destination,
                (_) => false,
                arguments: right.isNewUser
                    ? const PersonalInformationArgs(isOnboarding: true)
                    : null,
              );
            }
            _toastSuccess(
              right.resolvedMessage,
              fallback: Strings.otpVerifiedSuccess,
            );

            state = state.copyWith(
              authModel: saved,
              otpErrorMessage: null,
              isVerifyingOtp: false,
            );
          },
        )
        .catchError((error) {
          debugPrint('🔴 UNEXPECTED ERROR: $error');
          _toastError(Strings.somethingWentWrong);
          state = state.copyWith(isVerifyingOtp: false);
        });
  }

  Future<void> updateSessionProfile({
    required String name,
    required String phone,
  }) async {
    final current = state.authModel;
    if (current == null) return;

    final updated = AuthModel(
      id: current.id,
      name: name,
      phone: phone,
      email: current.email,
      profileImageUrl: current.profileImageUrl,
      customerId: current.customerId,
      countryCode: current.countryCode,
      status: current.status,
      accessToken: current.accessToken,
      refreshToken: current.refreshToken,
    );

    final isNewUser = await ref.read(sembastServicesProvider).isNewUser();
    final saved = await _saveSession(authModel: updated, isNewUser: isNewUser);
    state = state.copyWith(authModel: saved);
  }

  Future<void> markProfileCompleted() async {
    if (!await ref.read(sembastServicesProvider).isNewUser()) return;

    final session = await ref.read(sembastServicesProvider).getUserData();
    if (session == null) return;

    final current =
        state.authModel ?? AuthModel.fromSessionMap(session);

    await ref.read(sembastServicesProvider).saveUser(isNewUser: false);
    final saved = await _saveSession(authModel: current, isNewUser: false);
    state = state.copyWith(authModel: saved);
    debugPrint('🟢 PROFILE ONBOARDING: isNewUser cleared after profile save');
  }

  Future<void> signOut() async {
    final refresh = AppConstants.refreshToken ?? '';

    state = state.copyWith(isSigningOut: true);

    if (refresh.isNotEmpty) {
      await ref
          .read(authRepositoryProvider)
          .logout(refresh: refresh)
          .fold(
            (left) {
              debugPrint('🔴 API ERROR: ${left.message}');
              _toastError(
                resolveApiErrorMessage(
                  error: left,
                  fallback: Strings.somethingWentWrong,
                ),
              );
            },
            (right) {
              debugPrint('🟢 API SUCCESS: ${right.message}');
            },
          )
          .catchError((error) {
            debugPrint('🔴 UNEXPECTED ERROR: $error');
          });
    }

    await _clearSession();
    await _syncAfterLogout();
    _cancelResendTimer();
    phoneController.clear();
    otpController.clear();
    state = const AuthState();
    _toastSuccess(null, fallback: Strings.signedOut);
  }

  Future<void> clearSessionOnUnauthorized() async {
    await _clearSession();
    await _syncAfterLogout();
    _cancelResendTimer();
    phoneController.clear();
    otpController.clear();
    state = const AuthState();
  }

  Future<void> startResendTimer() async {
    _cancelResendTimer();
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

  Future<AuthModel?> _restoreSession() async {
    final session = await ref.read(sembastServicesProvider).getUserData();
    if (session == null) {
      AppConstants.clearSessionTokens();
      return null;
    }

    final access = convertToString(session['accessToken']);
    final refresh = convertToString(session['refreshToken']);
    if (access.isEmpty) {
      AppConstants.clearSessionTokens();
      return null;
    }

    AppConstants.setSessionTokens(access: access, refresh: refresh);
    return AuthModel.fromSessionMap(session);
  }

  Future<AuthModel> _saveSession({
    required AuthModel authModel,
    required bool isNewUser,
  }) async {
    await ref
        .read(sembastServicesProvider)
        .insertUserData(authModel.toSessionMap(isNewUser: isNewUser));
    AppConstants.setSessionTokens(
      access: authModel.accessToken ?? '',
      refresh: authModel.refreshToken ?? '',
    );
    return authModel;
  }

  Future<void> _clearSession() async {
    await ref.read(networkServicesProvider).cancelPendingRequests();
    await ref.read(sembastServicesProvider).clearLocalDb();
    AppConstants.clearSessionTokens();
  }

  Future<void> _syncAfterLogin() async {
    await ref.read(oneSignalServiceProvider).refreshDeviceRegistration();
    await ref.read(oneSignalServiceProvider).registerDeviceWithBackend();
    await ref.read(cartNotifierProvider.notifier).fetchCart(showLoader: true);
    await ref
        .read(wishlistNotifierProvider.notifier)
        .fetchWishlist(showLoader: true);
  }

  Future<void> _syncAfterLogout() async {
    await ref.read(oneSignalServiceProvider).clearIdentity();
    InvalidateDI.invalidate(ref);
  }

  void _toastError(String message) {
    showCustomErrorToast(message: message);
  }

  void _toastSuccess(String? message, {required String fallback}) {
    final text = (message == null || message.trim().isEmpty)
        ? fallback
        : message;
    if (text.isEmpty) return;
    showCustomToast(message: text, isSuccess: true);
  }

  void _cancelResendTimer() {
    _resendTimer?.cancel();
    _resendTimer = null;
  }
}

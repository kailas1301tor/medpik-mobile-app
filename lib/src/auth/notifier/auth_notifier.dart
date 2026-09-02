import 'dart:async';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/data/local/sembast_services.dart';
import 'package:medpik/data/remote/network_services.dart';
import 'package:medpik/res/constants/app_constants.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/services/invalidate_di.dart';
import 'package:medpik/services/onesignal_service.dart';
import 'package:medpik/services/repo_di.dart';
import 'package:medpik/data/models/personal_information_args.dart';
import 'package:medpik/src/auth/model/auth_model.dart';
import 'package:medpik/src/auth/state/auth_state.dart';
import 'package:medpik/src/root/medpik_app.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';
import 'package:medpik/utils/helpers/toast_helper.dart';
import 'package:medpik/utils/helpers/validators.dart';

import 'package:medpik/utils/routes/route_constants.dart';

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

  // ! ----------------------------------- API CALLS-----------------------------------

  Future<bool> requestOtp(BuildContext context) async {
    if (!_validatePhone()) return false;
    final phone = phoneController.text.trim();
    state = state.copyWith(isRequestingOtp: true, phoneErrorText: null);

    return ref
        .read(authRepositoryProvider)
        .requestOtp(phone: phone, countryCode: AppConstants.defaultCountryCode)
        .fold(
          (left) {
            state = state.copyWith(isRequestingOtp: false);
            showCustomToast(
              message: left.message ?? Strings.somethingWentWrong,
              isSuccess: false,
            );
            return false;
          },
          (right) async {
            otpController.clear();
            await startResendTimer();
            showCustomToast(message: right.message, isSuccess: true);
            state = state.copyWith(
              otpPhone: phone,
              otpFlow: AuthOtpFlow.login,
              otpErrorMessage: null,
              isOtpValid: false,
            );
            if (!context.mounted) {
              state = state.copyWith(isRequestingOtp: false);
              return false;
            }
            Navigator.pushNamed(context, RouteConstants.routeOtpScreen);
            state = state.copyWith(isRequestingOtp: false);
            return true;
          },
        )
        .catchError((error) {
          state = state.copyWith(isRequestingOtp: false);
          showCustomToast(
            message: Strings.somethingWentWrong,
            isSuccess: false,
          );
          return false;
        });
  }

  Future<void> resendOtp() async {
    if (state.otpFlow == AuthOtpFlow.login && !_validatePhone()) return;
    final phone = _otpPhoneForRequest();
    if (phone.isEmpty) return;
    if (_shouldBlockResendOtp()) {
      return;
    }
    state = state.copyWith(isResendingOtp: true);

    await ref
        .read(authRepositoryProvider)
        .resendOtp(
          phone: phone,
          countryCode: _countryCodeForRequest(),
        )
        .fold(
          (left) {
            showCustomToast(
              message: left.message ?? Strings.somethingWentWrong,
              isSuccess: false,
            );
          },
          (right) async {
            otpController.clear();
            await startResendTimer();
            state = state.copyWith(otpErrorMessage: null, isOtpValid: false);
            showCustomToast(message: right.message, isSuccess: true);
          },
        )
        .catchError((error) {
          showCustomToast(
            message: Strings.somethingWentWrong,
            isSuccess: false,
          );
        });
    state = state.copyWith(isResendingOtp: false);
  }

  Future<void> verifyOtp(BuildContext context) async {
    if (!_validateOtp()) return;
    if (_shouldBlockVerifyOtp()) {
      return;
    }

    if (state.otpFlow == AuthOtpFlow.deleteAccount) {
      await _confirmDeleteAccountWithOtp(context);
      return;
    }

    state = state.copyWith(isVerifyingOtp: true, otpErrorMessage: null);

    await ref
        .read(authRepositoryProvider)
        .verifyOtp(
          phone: _otpPhoneForRequest(),
          otp: otpController.text.trim(),
          countryCode: _countryCodeForRequest(),
        )
        .fold(
          (left) {
            showCustomToast(
              message: left.message ?? Strings.somethingWentWrong,
              isSuccess: false,
            );
            state = state.copyWith(
              otpErrorMessage: left.message ?? Strings.somethingWentWrong,
              isVerifyingOtp: false,
            );
          },
          (right) async {
            final authModel = right.authModel!;
            final saved = await _saveSession(
              authModel: authModel,
              isNewUser: right.isNewUser,
            );

            state = state.copyWith(authModel: saved, otpErrorMessage: null);

            if (!context.mounted) {
              state = state.copyWith(isVerifyingOtp: false);
              return;
            }
            _navigateToNextScreen(context, right.isNewUser);
            showCustomToast(message: right.resolvedMessage, isSuccess: true);
            state = state.copyWith(isVerifyingOtp: false);
          },
        )
        .catchError((error) {
          showCustomToast(
            message: Strings.somethingWentWrong,
            isSuccess: false,
          );
          state = state.copyWith(isVerifyingOtp: false);
        });
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
              showCustomToast(
                message: left.message ?? Strings.somethingWentWrong,
                isSuccess: false,
              );
            },
            (right) {
              showCustomToast(message: right.message, isSuccess: true);
            },
          )
          .catchError((error) {
            showCustomToast(
              message: Strings.somethingWentWrong,
              isSuccess: false,
            );
          });
    }

    await _clearSession();
    await _syncAfterLogout();
    _cancelResendTimer();
    phoneController.clear();
    otpController.clear();
    state = const AuthState();
  }

  Future<bool> startDeleteAccountOtpFlow(
    BuildContext context, {
    String? phoneOverride,
    String? countryCodeOverride,
  }) async {
    final authModel = state.authModel;
    final resolvedPhone = phoneOverride?.trim().isNotEmpty == true
        ? phoneOverride!.trim()
        : authModel?.phone.trim() ?? '';
    if (resolvedPhone.isEmpty) {
      debugPrint('🔴 DELETE ACCOUNT: missing phone in session/profile');
      showCustomErrorToast(message: Strings.somethingWentWrong);
      return false;
    }

    final countryCode = _resolveCountryCode(
      countryCodeOverride ?? authModel?.countryCode,
    );
    state = state.copyWith(
      isRequestingOtp: true,
      otpFlow: AuthOtpFlow.deleteAccount,
      otpErrorMessage: null,
    );

    return ref
        .read(authRepositoryProvider)
        .requestOtp(phone: resolvedPhone, countryCode: countryCode)
        .fold(
          (left) {
            state = state.copyWith(
              isRequestingOtp: false,
              otpFlow: AuthOtpFlow.login,
            );
            showCustomErrorToast(
              message: left.message ?? Strings.somethingWentWrong,
            );
            return false;
          },
          (right) async {
            otpController.clear();
            await startResendTimer();
            state = state.copyWith(
              otpPhone: resolvedPhone,
              otpFlow: AuthOtpFlow.deleteAccount,
              otpErrorMessage: null,
              isOtpValid: false,
              isRequestingOtp: false,
            );
            showCustomToast(message: right.message, isSuccess: true);
            final navigator = ref.read(navigatorKeyProvider).currentState;
            if (navigator == null) {
              debugPrint('🔴 DELETE ACCOUNT: navigator unavailable');
              showCustomErrorToast(message: Strings.somethingWentWrong);
              return false;
            }
            unawaited(navigator.pushNamed(RouteConstants.routeOtpScreen));
            return true;
          },
        )
        .catchError((error) {
          debugPrint('🔴 DELETE ACCOUNT OTP ERROR: $error');
          state = state.copyWith(
            isRequestingOtp: false,
            otpFlow: AuthOtpFlow.login,
          );
          showCustomErrorToast(message: Strings.somethingWentWrong);
          return false;
        });
  }

  Future<void> _confirmDeleteAccountWithOtp(BuildContext context) async {
    final phone = state.otpPhone?.trim() ?? '';
    if (phone.isEmpty) {
      showCustomErrorToast(message: Strings.somethingWentWrong);
      return;
    }

    state = state.copyWith(isDeletingAccount: true, otpErrorMessage: null);

    final deleted = await ref
        .read(authRepositoryProvider)
        .deleteAccount(
          phone: phone,
          otp: otpController.text.trim(),
          countryCode: _countryCodeForRequest(),
        )
        .fold(
          (left) {
            showCustomErrorToast(
              message: left.message ?? Strings.somethingWentWrong,
            );
            state = state.copyWith(
              otpErrorMessage: left.message ?? Strings.somethingWentWrong,
              isDeletingAccount: false,
            );
            return false;
          },
          (right) {
            showCustomToast(
              message: right.message.isNotEmpty
                  ? right.message
                  : Strings.deleteAccountSuccess,
              isSuccess: true,
            );
            return true;
          },
        )
        .catchError((error) {
          showCustomErrorToast(message: Strings.somethingWentWrong);
          state = state.copyWith(isDeletingAccount: false);
          return false;
        });

    if (!deleted) return;

    await _clearSession();
    await _syncAfterLogout();
    _cancelResendTimer();
    phoneController.clear();
    otpController.clear();
    state = const AuthState();

    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteConstants.routeLoginScreen,
      (route) => false,
    );
  }

  void resetOtpFlow() {
    if (state.otpFlow != AuthOtpFlow.deleteAccount) return;
    _cancelResendTimer();
    otpController.clear();
    state = state.copyWith(
      otpFlow: AuthOtpFlow.login,
      otpPhone: null,
      otpErrorMessage: null,
      isOtpValid: false,
      resendCountdown: 0,
    );
  }

  // ! ----------------------------------- API CALLS-----------------------------------

  // ============ UTILITY / INTERNAL LOGIC (Non-API) =====================

  /// Updates the session profile data (name and phone) both in-memory and in persistent storage.
  /// This should be called when the user edits their profile info in-app.
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

  /// Marks the profile as completed in the session and local storage.
  /// Intended to be called after the user has completed onboarding/profile setup.
  Future<void> markProfileCompleted() async {
    if (!await ref.read(sembastServicesProvider).isNewUser()) return;

    final session = await ref.read(sembastServicesProvider).getUserData();
    if (session == null) return;

    final current = state.authModel ?? AuthModel.fromSessionMap(session);

    await ref.read(sembastServicesProvider).saveUser(isNewUser: false);
    final saved = await _saveSession(authModel: current, isNewUser: false);
    state = state.copyWith(authModel: saved);
  }

  /// Clears all saved session/user data when access is unauthorized.
  /// This is typically used when a 401/unauthorized error is encountered.
  Future<void> clearSessionOnUnauthorized() async {
    await _clearSession();
    await _syncAfterLogout();
    _cancelResendTimer();
    phoneController.clear();
    otpController.clear();
    state = const AuthState();
  }

  // Timer logic used in preventing abuse of the OTP function
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

  /// Restore session state from persistence.
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

  /// Save session state to persistence.
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

  /// Completely clear current session and local DB.
  Future<void> _clearSession() async {
    await ref.read(networkServicesProvider).cancelPendingRequests();
    await ref.read(sembastServicesProvider).clearLocalDb();
    AppConstants.clearSessionTokens();
  }

  /// Handle any logout side effects and invalidate services (such as OneSignal identity).
  Future<void> _syncAfterLogout() async {
    await ref.read(oneSignalServiceProvider).clearIdentity();
    InvalidateDI.invalidate(ref);
  }

  // Cancel the OTP resend timer if running.
  void _cancelResendTimer() {
    _resendTimer?.cancel();
    _resendTimer = null;
  }

  /// Form field validation and state update helpers.
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

  // Called when the OTP field input is completed by user. Triggers verification only if not busy.
  void onOtpCompleted(BuildContext context) {
    if (state.isVerifyingOtp ||
        state.isResendingOtp ||
        state.isRequestingOtp ||
        state.isDeletingAccount) {
      return;
    }
    if (otpController.text.trim().length != AppConstants.otpLength) return;
    verifyOtp(context);
  }

  // ===== Logics kept for form/UX and robustness =====

  /// Prevent redundant verification requests while another auth action is running.
  bool _shouldBlockVerifyOtp() {
    return state.isVerifyingOtp ||
        state.isResendingOtp ||
        state.isRequestingOtp ||
        state.isDeletingAccount;
  }

  /// Validate OTP and update error state if not valid.
  bool _validateOtp() {
    final otp = otpController.text.trim();
    if (otp.length != AppConstants.otpLength) {
      state = state.copyWith(
        otpErrorMessage: Strings.invalidOtp,
        isOtpValid: false,
      );
      return false;
    }
    return true;
  }

  /// Call on app startup, restores session and updates state.
  Future<String?> bootstrap() async {
    await ref.read(sembastServicesProvider).initialize();
    final authModel = await _restoreSession();
    if (authModel == null) return null;
    state = state.copyWith(authModel: authModel);
    return authModel.id.toString();
  }

  /// Validate phone and update state with error.
  bool _validatePhone() {
    final phone = phoneController.text.trim();
    final phoneError = Validators.validatePhone(phone);
    if (phoneError != null) {
      state = state.copyWith(phoneErrorText: phoneError, isPhoneValid: false);
      return false;
    }
    return true;
  }

  /// Prevent sending OTP (either resend or initial) if waiting or busy.
  bool _shouldBlockResendOtp() {
    return state.isResendingOtp ||
        state.isRequestingOtp ||
        state.isVerifyingOtp ||
        state.isDeletingAccount ||
        state.resendCountdown > 0;
  }

  String _otpPhoneForRequest() {
    if (state.otpFlow == AuthOtpFlow.deleteAccount) {
      return state.otpPhone?.trim() ?? '';
    }
    return phoneController.text.trim().isNotEmpty
        ? phoneController.text.trim()
        : state.otpPhone?.trim() ?? '';
  }

  String _countryCodeForRequest() {
    if (state.otpFlow == AuthOtpFlow.deleteAccount) {
      return _resolveCountryCode(state.authModel?.countryCode);
    }
    return AppConstants.defaultCountryCode;
  }

  String _resolveCountryCode(String? countryCode) {
    final resolved = countryCode?.trim() ?? '';
    return resolved.isEmpty ? AppConstants.defaultCountryCode : resolved;
  }

  /// Navigation helper for OTP success.
  void _navigateToNextScreen(BuildContext context, bool isNewUser) {
    if (!context.mounted) return;
    final destination = isNewUser
        ? RouteConstants.routePersonalInformationScreen
        : RouteConstants.mainScreen;
    Navigator.pushNamedAndRemoveUntil(
      context,
      destination,
      (_) => false,
      arguments: isNewUser
          ? const PersonalInformationArgs(isOnboarding: true)
          : null,
    );
  }
}

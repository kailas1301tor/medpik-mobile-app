// lib/src/profile/notifier/profile_notifier.dart
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/data/local/sembast_services.dart';
import 'package:medpik/providers/auth_providers.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/services/repo_di.dart';
import 'package:medpik/src/profile/model/profile_model.dart';
import 'package:medpik/src/profile/repo/profile_repository.dart';
import 'package:medpik/src/profile/state/profile_state.dart';
import 'package:medpik/utils/helpers/api_error_handler.dart';
import 'package:medpik/utils/helpers/toast_helper.dart';

part 'profile_notifier.g.dart';

@Riverpod(keepAlive: false)
class ProfileNotifier extends _$ProfileNotifier {
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;

  late ProfileRepo profileRepo;

  @override
  ProfileState build() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    profileRepo = ref.read(profileRepositoryProvider);

    firstNameController.addListener(_onFirstNameChanged);
    lastNameController.addListener(_onLastNameChanged);

    ref.onDispose(() {
      firstNameController.removeListener(_onFirstNameChanged);
      lastNameController.removeListener(_onLastNameChanged);
      firstNameController.dispose();
      lastNameController.dispose();
    });

    Future.microtask(fetchProfile);
    return const ProfileState(loaderState: LoaderState.loading);
  }

  void _onFirstNameChanged() {
    if (state.firstNameError != null) {
      state = state.copyWith(firstNameError: null);
    }
    _syncFormValidity();
  }

  void _onLastNameChanged() {
    if (state.lastNameError != null) {
      state = state.copyWith(lastNameError: null);
    }
    _syncFormValidity();
  }

  void _syncFormValidity() {
    final isValid = firstNameController.text.trim().isNotEmpty &&
        lastNameController.text.trim().isNotEmpty;
    if (state.isProfileFormValid == isValid) return;
    state = state.copyWith(isProfileFormValid: isValid);
  }

  Future<void> fetchProfile() async {
    state = state.copyWith(loaderState: LoaderState.loading);

    return await profileRepo.getProfile().fold(
      (error) {
        final loaderState = handleResponseError(error.key);
        debugPrint("🔴 PROFILE ERROR: ${error.message}");
        showCustomErrorToast(
          message: error.message ?? Strings.somethingWentWrong,
        );
        state = state.copyWith(loaderState: loaderState);
      },
      (response) async {
        final profile = response.profile;
        if (profile == null) {
          state = state.copyWith(loaderState: LoaderState.noData);
          return;
        }

        debugPrint("🟢 PROFILE SUCCESS: $profile");
        state = state.copyWith(
          loaderState: LoaderState.loaded,
          profile: profile,
        );
        await _syncAuthSession(profile);
      },
    ).catchError((error) {
      debugPrint("🔴 UNEXPECTED PROFILE ERROR: $error");
      showCustomErrorToast(message: Strings.somethingWentWrong);
      state = state.copyWith(loaderState: LoaderState.error);
    });
  }

  void initEditForm() {
    final profile = state.profile;
    firstNameController.text = profile?.firstName ?? '';
    lastNameController.text = profile?.lastName ?? '';
    state = state.copyWith(firstNameError: null, lastNameError: null);
    _syncFormValidity();
  }

  Future<bool> updateProfile() async {
    if (state.isSaving) return false;

    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();

    if (firstName.isEmpty) {
      state = state.copyWith(firstNameError: Strings.firstNameRequired);
      return false;
    }

    if (lastName.isEmpty) {
      state = state.copyWith(lastNameError: Strings.lastNameRequired);
      return false;
    }

    state = state.copyWith(
      isSaving: true,
      firstNameError: null,
      lastNameError: null,
    );

    final payload = ProfileModel(
      firstName: firstName,
      lastName: lastName,
      phoneNumber: state.profile?.phoneNumber ?? '',
    );

    return await profileRepo.updateProfile(payload).fold(
      (error) {
        debugPrint("🔴 PROFILE UPDATE ERROR: ${error.message}");
        state = state.copyWith(isSaving: false);
        showCustomErrorToast(
          message: error.message ?? Strings.somethingWentWrong,
        );
        return false;
      },
      (response) async {
        final profile = response.profile;
        if (profile == null) {
          debugPrint("🔴 PROFILE UPDATE ERROR: missing profile data");
          state = state.copyWith(isSaving: false);
          showCustomErrorToast(message: Strings.somethingWentWrong);
          return false;
        }

        debugPrint("🟢 PROFILE UPDATE SUCCESS: $profile");
        state = state.copyWith(profile: profile, isSaving: false);
        await _syncAuthSession(profile);
        if (await ref.read(sembastServicesProvider).isNewUser()) {
          await ref.read(authNotifierProvider.notifier).markProfileCompleted();
        }
        showCustomToast(
          message: response.message.isNotEmpty
              ? response.message
              : Strings.profileUpdatedSuccess,
          isSuccess: true,
        );
        return true;
      },
    ).catchError((error) {
      debugPrint("🔴 UNEXPECTED PROFILE UPDATE ERROR: $error");
      state = state.copyWith(isSaving: false);
      showCustomErrorToast(message: Strings.somethingWentWrong);
      return false;
    });
  }

  Future<void> _syncAuthSession(ProfileModel profile) async {
    await ref.read(authNotifierProvider.notifier).updateSessionProfile(
          name: profile.displayName,
          phone: profile.phoneNumber,
        );
  }
}

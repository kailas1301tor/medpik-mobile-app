// lib/src/splash/notifier/splash_notifier.dart
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/res/constants/app_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/services/onesignal_service.dart';
import 'package:medpik/src/splash/state/splash_state.dart';

part 'splash_notifier.g.dart';

@Riverpod(keepAlive: false)
class SplashNotifier extends _$SplashNotifier {
  @override
  SplashState build() {
    Future.microtask(bootstrap);
    return const SplashState();
  }

  Future<void> bootstrap() async {
    if (state.loaderState == LoaderState.loaded) return;
    state = state.copyWith(loaderState: LoaderState.loading);

    try {
      await Future.delayed(const Duration(milliseconds: 1200));

      if (AppConstants.hasSession) {
        await ref.read(oneSignalServiceProvider).refreshDeviceRegistration();
      }

      final hasSession = AppConstants.hasSession;
      debugPrint('🔵 SPLASH: hasSession=$hasSession');
      state = state.copyWith(
        loaderState: LoaderState.loaded,
        hasSession: hasSession,
      );
    } catch (error) {
      debugPrint('🔴 SPLASH BOOTSTRAP ERROR: $error');
      state = state.copyWith(
        loaderState: LoaderState.loaded,
        hasSession: false,
      );
    }
  }
}

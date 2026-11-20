// lib/src/splash/notifier/splash_notifier.dart
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/res/constants/app_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/services/onesignal_service.dart';
import 'package:medpik/src/splash/state/splash_state.dart';
import 'package:medpik/utils/helpers/version_compare_helper.dart';

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
      await Future.delayed(
        Duration(milliseconds: AppConstants.splashMinDurationMs),
      );

      final requiresForceUpdate = await _checkForceUpdateRequired();
      if (requiresForceUpdate) {
        debugPrint('🔴 SPLASH: force update required');
        state = state.copyWith(
          loaderState: LoaderState.loaded,
          requiresForceUpdate: true,
          hasSession: false,
        );
        return;
      }

      if (AppConstants.hasSession) {
        await ref.read(oneSignalServiceProvider).refreshDeviceRegistration();
      }

      final hasSession = AppConstants.hasSession;
      debugPrint('🔵 SPLASH: hasSession=$hasSession');
      state = state.copyWith(
        loaderState: LoaderState.loaded,
        hasSession: hasSession,
        requiresForceUpdate: false,
      );
    } catch (error) {
      debugPrint('🔴 SPLASH BOOTSTRAP ERROR: $error');
      state = state.copyWith(
        loaderState: LoaderState.loaded,
        hasSession: false,
        requiresForceUpdate: false,
      );
    }
  }

  Future<bool> _checkForceUpdateRequired() async {
    final minimum = AppConstants.minAppVersion.trim();
    if (minimum.isEmpty) return false;

    try {
      final info = await PackageInfo.fromPlatform();
      final current = info.version.trim();
      debugPrint('🔵 SPLASH version check current=$current min=$minimum');
      return isAppVersionBelowMinimum(current: current, minimum: minimum);
    } catch (error) {
      debugPrint('🟡 SPLASH version check skipped: $error');
      return false;
    }
  }
}

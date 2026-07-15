// lib/src/splash/notifier/splash_notifier.dart
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/res/constants/app_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/src/auth/notifier/auth_notifier.dart';
import 'package:tsuite/src/splash/state/splash_state.dart';
import 'package:tsuite/src/wishlist/notifier/wishlist_notifier.dart';

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
    await Future.delayed(const Duration(milliseconds: 1200));

    await ref.read(authNotifierProvider.notifier).restoreSessionToState();
    final hasSession = AppConstants.hasSession;

    if (hasSession) {
      await ref.read(wishlistNotifierProvider.notifier).fetchWishlist();
    }

    debugPrint('🔵 SPLASH: hasSession=$hasSession');
    state = state.copyWith(
      loaderState: LoaderState.loaded,
      hasSession: hasSession,
    );
  }
}

// lib/services/session_bootstrap_service.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/res/constants/app_constants.dart';
import 'package:tsuite/services/wishlist_facade_service.dart';
import 'package:tsuite/src/auth/notifier/auth_notifier.dart';

part 'session_bootstrap_service.g.dart';

@Riverpod(keepAlive: true)
SessionBootstrapService sessionBootstrapService(Ref ref) {
  return SessionBootstrapService(ref);
}

class SessionBootstrapService {
  const SessionBootstrapService(this._ref);

  final Ref _ref;

  Future<bool> bootstrap() async {
    await _ref.read(authNotifierProvider.notifier).restoreSessionToState();

    if (AppConstants.hasSession) {
      await _ref.read(wishlistFacadeServiceProvider).fetchWishlist();
    }

    return AppConstants.hasSession;
  }
}

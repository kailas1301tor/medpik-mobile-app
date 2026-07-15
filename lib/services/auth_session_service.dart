// lib/services/auth_session_service.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/data/local/sembast_services.dart';
import 'package:tsuite/res/constants/app_constants.dart';
import 'package:tsuite/src/auth/model/auth_model.dart';
import 'package:tsuite/utils/helpers/safe_converters.dart';

part 'auth_session_service.g.dart';

class SessionData {
  const SessionData({
    required this.authModel,
    required this.isNewUser,
  });

  final AuthModel authModel;
  final bool isNewUser;
}

@Riverpod(keepAlive: true)
AuthSessionService authSessionService(Ref ref) {
  return AuthSessionService(ref);
}

class AuthSessionService {
  AuthSessionService(this._ref);

  final Ref _ref;

  SembastServices get _sembast => _ref.read(sembastServicesProvider);

  Future<void> initialize() async {
    await _sembast.initialize();
  }

  Future<SessionData?> restore() async {
    try {
      final session = await _sembast.getUserData();
      if (session == null) {
        AppConstants.clearSessionTokens();
        debugPrint('🔵 SESSION: no stored session');
        return null;
      }

      final access = convertToString(session['accessToken']);
      final refresh = convertToString(session['refreshToken']);
      if (access.isEmpty) {
        AppConstants.clearSessionTokens();
        debugPrint('🔵 SESSION: session missing access token');
        return null;
      }

      AppConstants.setSessionTokens(access: access, refresh: refresh);
      final authModel = AuthModel.fromSessionMap(session);
      final isNewUser = convertToBool(session['isNewUser']);
      debugPrint('🟢 SESSION: restored user ${authModel.id}');
      return SessionData(authModel: authModel, isNewUser: isNewUser);
    } catch (e) {
      debugPrint('🔴 SESSION restore ERROR: $e');
      AppConstants.clearSessionTokens();
      return null;
    }
  }

  Future<AuthModel> save(VerifyOtpResult result) async {
    final authModel = result.authModel;
    await _sembast.insertUserData(
      authModel.toSessionMap(isNewUser: result.isNewUser),
    );
    AppConstants.setSessionTokens(
      access: authModel.accessToken ?? '',
      refresh: authModel.refreshToken ?? '',
    );
    debugPrint(
      '🟢 SESSION: saved user ${authModel.id}, isNewUser=${result.isNewUser}',
    );
    return authModel;
  }

  Future<void> clear() async {
    await _sembast.clearLocalDb();
    AppConstants.clearSessionTokens();
    debugPrint('🟢 SESSION: cleared');
  }

  bool get hasSession => AppConstants.hasSession;
}

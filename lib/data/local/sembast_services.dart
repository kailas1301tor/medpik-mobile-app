// lib/data/local/sembast_services.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sembast/sembast_io.dart';
import 'package:medpik/data/local/local_base_services.dart';
import 'package:medpik/data/local/secure_token_store.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';

part 'sembast_services.g.dart';

@Riverpod(keepAlive: true)
SembastServices sembastServices(Ref<SembastServices> ref) {
  return SembastServices();
}

class SembastServices extends LocalBaseServices {
  SembastServices({SecureTokenStore? tokenStore})
    : _tokenStore = tokenStore ?? SecureTokenStore();

  String dbPath = 'medpik_app.db';
  final _legacyTokenStore = StoreRef<String, Map<String, dynamic>>(
    'auth_tokens',
  );
  final _userStore = StoreRef<String, Map<String, dynamic>>('user_session');
  final _userStatus = StoreRef<String, String>('user_status');
  final SecureTokenStore _tokenStore;

  Database? _db;
  bool _initialized = false;

  Database get db {
    final database = _db;
    if (database == null) {
      throw StateError('SembastServices.initialize() must be called first');
    }
    return database;
  }

  @override
  Future<void> initialize() async {
    if (_initialized && _db != null) return;
    final appDir = await getApplicationDocumentsDirectory();
    _db = await databaseFactoryIo.openDatabase('${appDir.path}/$dbPath');
    _initialized = true;
    await _migrateLegacyTokensIfNeeded();
    debugPrint('🟢 SEMBAST: initialized medpik_app.db');
  }

  /// Move plaintext tokens from Sembast → secure storage once, then scrub DB.
  Future<void> _migrateLegacyTokensIfNeeded() async {
    try {
      final existingAccess = await _tokenStore.getAccessToken();
      if (existingAccess != null && existingAccess.isNotEmpty) {
        await _scrubLegacyTokenCopies();
        return;
      }

      String access = '';
      String refresh = '';

      final legacyTokens = await _legacyTokenStore.record('tokens').get(db);
      if (legacyTokens != null) {
        access = convertToString(legacyTokens['accessToken']);
        refresh = convertToString(legacyTokens['refreshToken']);
      }

      if (access.isEmpty) {
        final session = await _userStore.record('session').get(db);
        if (session != null) {
          access = convertToString(session['accessToken']);
          refresh = convertToString(session['refreshToken']);
        }
      }

      if (access.isNotEmpty) {
        await _tokenStore.saveTokens(
          accessToken: access,
          refreshToken: refresh,
        );
        debugPrint('🟢 SEMBAST: migrated tokens to secure storage');
      }

      await _scrubLegacyTokenCopies();
    } catch (e) {
      debugPrint('🔴 SEMBAST token migration: $e');
    }
  }

  Future<void> _scrubLegacyTokenCopies() async {
    try {
      await _legacyTokenStore.record('tokens').delete(db);
      final session = await _userStore.record('session').get(db);
      if (session == null) return;
      if (!session.containsKey('accessToken') &&
          !session.containsKey('refreshToken')) {
        return;
      }
      final scrubbed = Map<String, dynamic>.from(session)
        ..remove('accessToken')
        ..remove('refreshToken');
      await _userStore.record('session').put(db, scrubbed);
    } catch (e) {
      debugPrint('🔴 SEMBAST scrub legacy tokens: $e');
    }
  }

  Map<String, dynamic> _sessionWithoutTokens(Map<String, dynamic> session) {
    final copy = Map<String, dynamic>.from(session)
      ..remove('accessToken')
      ..remove('refreshToken');
    return copy;
  }

  @override
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final data = await _userStore.record('session').get(db);
      if (data == null) return null;
      final session = Map<String, dynamic>.from(data);
      final access = await getAccessToken();
      final refresh = await getRefreshToken();
      if (access != null && access.isNotEmpty) {
        session['accessToken'] = access;
      }
      if (refresh != null && refresh.isNotEmpty) {
        session['refreshToken'] = refresh;
      }
      return session;
    } catch (e) {
      debugPrint('🔴 SEMBAST getUserData: $e');
      return null;
    }
  }

  @override
  Future<void> insertUserData(Map<String, dynamic> session) async {
    try {
      final access = convertToString(session['accessToken']);
      final refresh = convertToString(session['refreshToken']);
      if (access.isNotEmpty) {
        await saveTokens(accessToken: access, refreshToken: refresh);
      }
      await _userStore.record('session').put(db, _sessionWithoutTokens(session));
      final isNewUser = convertToBool(session['isNewUser']);
      await saveUser(isNewUser: isNewUser);
      debugPrint('🟢 SEMBAST: session saved for user ${session['userId']}');
    } catch (e) {
      debugPrint('🔴 SEMBAST insertUserData: $e');
    }
  }

  @override
  Future<void> deleteUserData() async {
    try {
      await _userStore.record('session').delete(db);
      await _userStatus.record('isNewUser').delete(db);
    } catch (e) {
      debugPrint('🔴 SEMBAST deleteUserData: $e');
    }
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      await _tokenStore.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
      await _scrubLegacyTokenCopies();
    } catch (e) {
      debugPrint('🔴 SEMBAST saveTokens: $e');
    }
  }

  @override
  Future<void> saveUser({required bool isNewUser}) async {
    try {
      await _userStatus.record('isNewUser').put(db, isNewUser.toString());
    } catch (e) {
      debugPrint('🔴 SEMBAST saveUser: $e');
    }
  }

  @override
  Future<bool> isNewUser() async {
    try {
      final status = await _userStatus.record('isNewUser').get(db);
      return status == 'true';
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      final fromSecure = await _tokenStore.getAccessToken();
      if (fromSecure != null && fromSecure.isNotEmpty) return fromSecure;
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      final fromSecure = await _tokenStore.getRefreshToken();
      if (fromSecure != null && fromSecure.isNotEmpty) return fromSecure;
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> clearLocalDb() async {
    try {
      await _userStatus.delete(db);
      await _legacyTokenStore.delete(db);
      await _userStore.delete(db);
      await _tokenStore.clear();
      debugPrint('🟢 SEMBAST: local auth data cleared');
      return true;
    } catch (e) {
      debugPrint('🔴 SEMBAST clearLocalDb: $e');
      return false;
    }
  }
}

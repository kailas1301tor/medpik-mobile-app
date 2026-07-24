// lib/data/local/sembast_services.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sembast/sembast_io.dart';
import 'package:medpik/data/local/local_base_services.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';

part 'sembast_services.g.dart';

@Riverpod(keepAlive: true)
SembastServices sembastServices(Ref<SembastServices> ref) {
  return SembastServices();
}

class SembastServices extends LocalBaseServices {
  String dbPath = 'medpik_app.db';
  final _tokenStore = StoreRef<String, Map<String, dynamic>>('auth_tokens');
  final _userStore = StoreRef<String, Map<String, dynamic>>('user_session');
  final _userStatus = StoreRef<String, String>('user_status');

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
    debugPrint('🟢 SEMBAST: initialized medpik_app.db');
  }

  @override
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final data = await _userStore.record('session').get(db);
      if (data == null) return null;
      return Map<String, dynamic>.from(data);
    } catch (e) {
      debugPrint('🔴 SEMBAST getUserData: $e');
      return null;
    }
  }

  @override
  Future<void> insertUserData(Map<String, dynamic> session) async {
    try {
      await _userStore.record('session').put(db, session);
      final isNewUser = convertToBool(session['isNewUser']);
      await saveUser(isNewUser: isNewUser);
      final access = convertToString(session['accessToken']);
      final refresh = convertToString(session['refreshToken']);
      if (access.isNotEmpty) {
        await saveTokens(accessToken: access, refreshToken: refresh);
      }
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
      await _tokenStore.record('tokens').put(db, {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      });
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
      final session = await getUserData();
      if (session != null) {
        final fromSession = convertToString(session['accessToken']);
        if (fromSession.isNotEmpty) return fromSession;
      }
      final token = await _tokenStore.record('tokens').get(db);
      return token?['accessToken'] as String?;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      final session = await getUserData();
      if (session != null) {
        final fromSession = convertToString(session['refreshToken']);
        if (fromSession.isNotEmpty) return fromSession;
      }
      final token = await _tokenStore.record('tokens').get(db);
      return token?['refreshToken'] as String?;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> clearLocalDb() async {
    try {
      await _userStatus.delete(db);
      await _tokenStore.delete(db);
      await _userStore.delete(db);
      debugPrint('🟢 SEMBAST: local auth data cleared');
      return true;
    } catch (e) {
      debugPrint('🔴 SEMBAST clearLocalDb: $e');
      return false;
    }
  }
}

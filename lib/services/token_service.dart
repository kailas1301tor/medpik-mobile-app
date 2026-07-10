import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service for managing encrypted storage of authentication tokens.
class TokenService {
  final FlutterSecureStorage _storage;

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  TokenService(this._storage);

  /// Saves both access and refresh tokens.
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
    ]);
  }

  /// Retrieves the stored access token.
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Retrieves the stored refresh token.
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Deletes all stored tokens (use on logout).
  Future<void> clearTokens() async {
    await _storage.deleteAll();
  }
}

/// Provider for the [TokenService] instance.
final tokenServiceProvider = Provider<TokenService>((ref) {
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
  return TokenService(storage);
});

/// Reactive provider for the access token.
/// Other services (like NetworkServices) can watch this.
final accessTokenProvider = FutureProvider<String?>((ref) async {
  final service = ref.watch(tokenServiceProvider);
  return await service.getAccessToken();
});

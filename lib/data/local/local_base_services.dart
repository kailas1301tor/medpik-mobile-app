// lib/data/local/local_base_services.dart
abstract class LocalBaseServices {
  Future<void> initialize();

  Future<Map<String, dynamic>?> getUserData();

  Future<void> insertUserData(Map<String, dynamic> session);

  Future<void> deleteUserData();

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<bool> clearLocalDb();

  Future<void> saveUser({required bool isNewUser});

  Future<bool> isNewUser();
}

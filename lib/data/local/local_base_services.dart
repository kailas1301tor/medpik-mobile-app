abstract class LocalBaseServices {
  Future<void> initialize();

  Future<void> getUserData();

  Future<void> insertUserData();

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

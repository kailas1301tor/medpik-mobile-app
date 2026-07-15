// lib/res/constants/app_constants.dart
class AppConstants {
  static const String baseURL = 'https://medpik-backend.onrender.com';
  static const int otpResendDuration = 60;

  /// Hardcoded country code for OTP auth (India).
  static const String defaultCountryCode = '+91';

  /// When true, non-auth repositories use mock implementations.
  /// Auth always uses the live AuthRepoImpl regardless of this flag.
  static const bool useMockData = true;

  /// Max file size for prescription uploads (images and documents).
  static const int maxImageSizeMb = 10;

  /// Google Maps / Places / Geocoding key used as Dart HTTP fallback.
  /// Prefer `--dart-define=GOOGLE_MAPS_API_KEY=...` and platform keys in
  /// AndroidManifest / AppDelegate. Restrict this key in Google Cloud Console.
  /// Empty default avoids REQUEST_DENIED spam when no Cloud project is wired.
  static const String googleApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: '',
  );

  static String api = '/api';
  static String version = '/v1';
  static String user = '/user';
  static String auth = '/auth';
  static String general = '/general';
  static String prefix = '$api$version';
  static String authPrefix = '$api$auth';

  // Auth endpoints
  /// Placeholder until logout path is confirmed by backend.
  static String logout = '$authPrefix/logout';
  static String requestOtp = '$authPrefix/request-otp';
  static String verifyOtp = '$authPrefix/verify-otp';
  static String resendOtp = requestOtp;

  // Catalog endpoints
  static String products = '$prefix$user/products';
  static String categories = '$prefix$user/categories';
  static String homeFeed = '$api/customer-home';
  static String customerProductDetail = '$api/customer-products/detail';

  // Orders & addresses
  static String orders = '$prefix$user/orders';
  static String addresses = '$prefix$user/addresses';
  static String prescriptions = '$prefix$user/prescriptions';

  // Profile endpoints
  static String getProfileData = '$prefix$user/profile';

  /// Runtime access token hydrated from Sembast on bootstrap / login.
  static String? accessToken;

  /// Runtime refresh token hydrated from Sembast on bootstrap / login.
  static String? refreshToken;

  static bool get hasSession => accessToken != null && accessToken!.isNotEmpty;

  static void setSessionTokens({
    required String access,
    required String refresh,
  }) {
    accessToken = access;
    refreshToken = refresh;
  }

  static void clearSessionTokens() {
    accessToken = null;
    refreshToken = null;
  }
}

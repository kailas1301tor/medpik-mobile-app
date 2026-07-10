class AppConstants {
  // TODO: Update these with your actual API URLs
  static const String baseURL = "https://api.example.com";
  static const int otpResendDuration = 60;

  /// When true, repositories use mock implementations.
  static const bool useMockData = true;

  /// Max file size for prescription uploads (images and documents).
  static const int maxImageSizeMb = 10;

  /// Mock phone number that simulates a suspended account.
  static const String suspendedTestPhone = '9999999999';

  static String api = "/api";
  static String version = "/v1";
  static String user = "/user";
  static String general = "/general";
  static String prefix = "$api$version";

  // Auth endpoints
  static String login = "$prefix$user/login";
  static String register = "$prefix$user/register";
  static String refreshTokenApi = "$prefix$user/token-refresh";
  static String logout = "$prefix$user/logout";
  static String requestOtp = "$prefix$user/otp/request";
  static String verifyOtp = "$prefix$user/otp/verify";
  static String resendOtp = "$prefix$user/otp/resend";

  // Catalog endpoints
  static String products = "$prefix$user/products";
  static String categories = "$prefix$user/categories";
  static String homeFeed = "$prefix$user/home";

  // Orders & addresses
  static String orders = "$prefix$user/orders";
  static String addresses = "$prefix$user/addresses";
  static String prescriptions = "$prefix$user/prescriptions";

  // Profile endpoints
  static String getProfileData = "$prefix$user/profile";
}

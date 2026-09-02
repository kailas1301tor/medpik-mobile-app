// lib/res/constants/app_constants.dart
import 'package:flutter/foundation.dart';
import 'package:medpik/res/enums/app_environment.dart';

class AppConstants {
  static String baseURL = AppEnvironment.stage.baseUrl;
  static AppEnvironment environment = AppEnvironment.stage;
  static const int otpResendDuration = 60;
  static const int otpLength = 6;

  /// Minimum time splash stays visible before navigating onward.
  static const int splashMinDurationMs = 3000;

  /// Hardcoded country code for OTP auth (India).
  static const String defaultCountryCode = '+91';

  /// Max file size for prescription uploads (images and documents).
  static const int maxImageSizeMb = 5;

  /// Google Maps / Places / Geocoding key used as Dart HTTP fallback.
  /// Prefer `--dart-define=GOOGLE_MAPS_API_KEY=...` and platform keys in
  /// AndroidManifest / AppDelegate. Restrict this key in Google Cloud Console.
  /// Empty default avoids REQUEST_DENIED spam when no Cloud project is wired.
  static const String googleApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: '',
  );

  /// OneSignal App ID from dashboard Settings > Keys & IDs.
  /// Override at build time: `--dart-define=ONESIGNAL_APP_ID=...`
  static const String oneSignalAppId = String.fromEnvironment(
    'ONESIGNAL_APP_ID',
    defaultValue: 'bc15686a-2431-4099-8916-1f2c0ff361ac',
  );

  static String api = '/api';
  static String version = '/v1';
  static String user = '/user';
  static String auth = '/auth';
  static String general = '/general';
  static String prefix = '$api$version';
  static String authPrefix = '$api$auth';

  // Auth endpoints
  static String logout = '$authPrefix/logout';
  static String requestOtp = '$authPrefix/request-otp';
  static String verifyOtp = '$authPrefix/verify-otp';
  static String deleteAccount = '$authPrefix/delete-account';
  static String resendOtp = requestOtp;

  // Catalog endpoints
  static String products = '$prefix$user/products';
  static String categories = '$prefix$user/categories';
  static String homeFeed = '$api/customer-home';
  static String customerGeneralData = '$api/customer-general-data';
  static String customerProducts = '$api/customer-products';
  static String customerProductsSearch = '$api/customer-products/search';
  static String customerProductDetail = '$api/customer-products/detail';

  /// GET wishlist list / POST toggle (`product_id`).
  static String wishlist = '$api/wishlist';

  /// GET cart / POST add (quantity > 0) / DELETE remove (`item_ids`).
  static String cart = '$api/cart';

  // Orders & addresses
  static String orders = '$api/orders';
  static String ordersBillAction = '$api/orders/bill-action';
  static String ordersPayment = '$api/orders/payment';
  static String ordersPaymentInit = '$api/orders/payment/init';
  static String addresses = '$api/addresses';

  // Profile endpoints
  static String customerProfile = '$api/customer-profile';
  static String storeProfile = '$api/core/app/store-profile/';

  // Device endpoints
  static String devicesRegister = '$api/devices/register';

  // Notification endpoints
  static String notificationsInApp = '$api/devices/in-app';

  // Emergency endpoints
  static String emergencyServices = '$api/emergency/services';

  /// Privacy policy on the public Medpik website (environment-aware).
  static String get privacyPolicyUrl =>
      '${environment.webBaseUrl}/legal/privacy-policy';

  /// Terms & conditions on the public Medpik website (environment-aware).
  static String get termsAndConditionsUrl =>
      '${environment.webBaseUrl}/legal/terms-and-conditions';

  /// Backend-accepted platform values for device registration.
  static const String devicePlatformAndroid = 'android';
  static const String devicePlatformIos = 'ios';

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

  static void configureEnvironment(AppEnvironment env) {
    environment = env;
    baseURL = env.baseUrl;
    debugPrint('🟢 API ENV: ${env.name} → $baseURL');
    debugPrint('🟢 WEB ENV: ${env.name} → ${env.webBaseUrl}');
    if (baseURL.isEmpty) {
      debugPrint('🔴 API ENV WARNING: baseURL is empty for ${env.name}');
    }
  }
}

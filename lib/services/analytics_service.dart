// lib/services/analytics_service.dart
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:medpik/services/crash_reporting_service.dart';

/// Light funnel analytics. No-ops when Firebase is unavailable.
class AnalyticsService {
  AnalyticsService._();

  static final AnalyticsService instance = AnalyticsService._();

  FirebaseAnalytics? get _analytics {
    if (!CrashReportingService.instance.isFirebaseReady) return null;
    return FirebaseAnalytics.instance;
  }

  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    final analytics = _analytics;
    if (analytics == null) {
      debugPrint('🟡 ANALYTICS skipped ($name) — Firebase not ready');
      return;
    }
    try {
      await analytics.logEvent(name: name, parameters: parameters);
      debugPrint('🟢 ANALYTICS: $name $parameters');
    } catch (error) {
      debugPrint('🔴 ANALYTICS ERROR ($name): $error');
    }
  }

  Future<void> logLoginSuccess({required bool isNewUser}) => logEvent(
    'login_success',
    parameters: {'is_new_user': isNewUser ? 1 : 0},
  );

  Future<void> logAddToCart({required int productId}) => logEvent(
    'add_to_cart',
    parameters: {'product_id': productId},
  );

  Future<void> logPlaceOrder({required String source}) =>
      logEvent('place_order', parameters: {'source': source});

  Future<void> logPaymentResult({required String outcome}) =>
      logEvent('payment_result', parameters: {'outcome': outcome});
}

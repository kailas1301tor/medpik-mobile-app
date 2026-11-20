// lib/services/crash_reporting_service.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:medpik/firebase_options.dart';

/// Global crash / error reporting. Soft-fails when Firebase is not configured
/// (missing `google-services.json` / `GoogleService-Info.plist`).
///
/// Collection is disabled in debug. Profile/release report to Crashlytics.
/// Optional smoke test:
///   flutter run --profile --dart-define=CRASHLYTICS_TEST_NONFATAL=true
class CrashReportingService {
  CrashReportingService._();

  static final CrashReportingService instance = CrashReportingService._();

  static const bool _sendTestNonFatal = bool.fromEnvironment(
    'CRASHLYTICS_TEST_NONFATAL',
  );

  bool _firebaseReady = false;

  bool get isFirebaseReady => _firebaseReady;

  Future<void> initialize() async {
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      recordFlutterFatalError(details);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      recordError(error, stack, fatal: true);
      return true;
    };

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
        !kDebugMode,
      );
      FlutterError.onError = (details) {
        FlutterError.presentError(details);
        if (kDebugMode) {
          debugPrint('🔴 FLUTTER ERROR: ${details.exceptionAsString()}');
          debugPrint('${details.stack}');
        } else {
          FirebaseCrashlytics.instance.recordFlutterFatalError(details);
        }
      };
      _firebaseReady = true;
      debugPrint('🟢 CRASH REPORTING: Firebase Crashlytics ready');

      if (!kDebugMode) {
        await FirebaseCrashlytics.instance.sendUnsentReports();
      }

      if (!kDebugMode && _sendTestNonFatal) {
        await recordTestNonFatal();
      }
    } catch (error, stack) {
      _firebaseReady = false;
      debugPrint(
        '🟡 CRASH REPORTING: Firebase unavailable ($error). '
        'Global handlers still active (local logging only).',
      );
      debugPrint('$stack');
    }
  }

  /// Non-fatal smoke test for profile/release → Crashlytics console.
  Future<void> recordTestNonFatal() async {
    debugPrint('🔵 CRASH REPORTING: sending non-fatal smoke test');
    await recordError(
      Exception('Medpik Crashlytics non-fatal smoke test'),
      StackTrace.current,
      fatal: false,
      reason: 'CRASHLYTICS_TEST_NONFATAL',
    );
    if (_firebaseReady && !kDebugMode) {
      await FirebaseCrashlytics.instance.sendUnsentReports();
      debugPrint(
        '🟢 CRASH REPORTING: non-fatal smoke test queued/sent '
        '(check Firebase Console → Crashlytics for medpik-ea048)',
      );
    }
  }

  void recordFlutterFatalError(FlutterErrorDetails details) {
    if (_firebaseReady && !kDebugMode) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      return;
    }
    debugPrint('🔴 FLUTTER FATAL: ${details.exceptionAsString()}');
    debugPrint('${details.stack}');
  }

  void recordZoneError(Object error, StackTrace stack) {
    recordError(error, stack, fatal: true);
  }

  Future<void> recordError(
    Object error,
    StackTrace? stack, {
    bool fatal = false,
    String? reason,
  }) async {
    if (_firebaseReady && !kDebugMode) {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stack,
        fatal: fatal,
        reason: reason,
      );
      return;
    }
    debugPrint('🔴 UNCAUGHT ERROR (fatal=$fatal): $error');
    if (reason != null) debugPrint('reason=$reason');
    if (stack != null) debugPrint('$stack');
  }
}

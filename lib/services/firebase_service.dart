// lib/services/firebase_service.dart
import 'package:medpik/services/crash_reporting_service.dart';

/// Firebase bootstrap entrypoint. Prefer [CrashReportingService.initialize]
/// from `main.dart` — that owns Crashlytics + global error hooks.
Future<void> initializeFirebase() => CrashReportingService.instance.initialize();

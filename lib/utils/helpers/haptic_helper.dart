// lib/utils/helpers/haptic_helper.dart
import 'package:flutter/services.dart';

/// Central haptic feedback helpers for consistent tactile UX.
///
/// Prefer these over calling [HapticFeedback] directly from widgets.
abstract final class AppHaptics {
  /// Tab switches, chips, toggles, list-row taps.
  static Future<void> selection() => HapticFeedback.selectionClick();

  /// Primary / secondary button presses.
  static Future<void> light() => HapticFeedback.lightImpact();

  /// Confirmations and notable positive outcomes.
  static Future<void> medium() => HapticFeedback.mediumImpact();

  /// Destructive or error outcomes.
  static Future<void> heavy() => HapticFeedback.heavyImpact();

  static Future<void> success() => medium();

  static Future<void> error() => heavy();
}

import 'package:flutter/material.dart';

/// Show a standard toast message.
void showCustomToast({required String message}) {
  debugPrint('✅ SUCCESS: $message');
  // Implementation note: integration with native/custom toast library would happen here.
}

/// Show a standard error toast message.
void showCustomErrorToast({required String message}) {
  debugPrint('❌ ERROR: $message');
  // Implementation note: integration with native/custom toast library would happen here.
}

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medpik/utils/helpers/connectivity_result_helper.dart';

export 'package:medpik/utils/helpers/debounce_helper.dart';
export 'package:medpik/utils/helpers/throttle_helper.dart';
export 'package:medpik/utils/helpers/toast_helper.dart';

/// Check if the device reports a network interface (not reachability).
Future<bool> isInternetAvailable() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  return isOnlineFromConnectivityResults(connectivityResult);
}

/// Execute a callback after the current frame.
void executeAfterFrame(VoidCallback callback) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    callback();
  });
}

/// Standalone Date Formatter - Use context extensions for simpler format.
String formatDate(DateTime date, {String pattern = 'dd MMM yyyy'}) =>
    DateFormat(pattern).format(date);

/// Format numeric values into calories string.
String formatCalories(num value) =>
    '${NumberFormat('#,###').format(value)} kcal';

/// Get the maximum phone number length based on the country code.
int getPhoneMaxLength(String countryCode) {
  return switch (countryCode) {
    '+91' => 10,
    '+1' => 10,
    '+44' => 10,
    _ => 15,
  };
}
void configureImageCache() {
  final imageCache = PaintingBinding.instance.imageCache;
  // Keep mid-device RAM in check while still caching a browse session.
  imageCache.maximumSize = 150;
  imageCache.maximumSizeBytes = 80 << 20; // 80 MB
}
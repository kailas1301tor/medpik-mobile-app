import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

export 'package:medpik/utils/helpers/debounce_helper.dart';
export 'package:medpik/utils/helpers/throttle_helper.dart';
export 'package:medpik/utils/helpers/toast_helper.dart';

/// Check if the device has an active internet connection.
Future<bool> isInternetAvailable() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  return !connectivityResult.contains(ConnectivityResult.none);
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
  imageCache.maximumSize = 500;
  imageCache.maximumSizeBytes = 200 << 20;
}
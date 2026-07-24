// lib/utils/helpers/device_platform_helper.dart
import 'dart:io';

import 'package:medpik/res/constants/app_constants.dart';

String? resolveDevicePlatform() {
  if (Platform.isAndroid) return AppConstants.devicePlatformAndroid;
  if (Platform.isIOS) return AppConstants.devicePlatformIos;
  return null;
}

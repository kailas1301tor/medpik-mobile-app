// lib/utils/helpers/store_launch_helper.dart
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:medpik/res/constants/app_constants.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/utils/helpers/toast_helper.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> launchAppStoreListing() async {
  final rawUrl = (!kIsWeb && Platform.isIOS)
      ? AppConstants.iosStoreUrl
      : AppConstants.androidStoreUrl;
  final uri = Uri.tryParse(rawUrl.trim());
  if (uri == null || !uri.hasScheme) {
    showCustomErrorToast(message: Strings.couldNotOpenStore);
    return false;
  }

  try {
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      showCustomErrorToast(message: Strings.couldNotOpenStore);
    }
    return launched;
  } catch (error) {
    debugPrint('🔴 STORE LAUNCH ERROR: $error');
    showCustomErrorToast(message: Strings.couldNotOpenStore);
    return false;
  }
}

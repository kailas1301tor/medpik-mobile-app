// lib/utils/helpers/email_launch_helper.dart
import 'package:flutter/material.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/utils/helpers/toast_helper.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> launchSupportEmail(String email) async {
  final uri = buildSupportEmailUri(email);
  if (uri == null) {
    showCustomErrorToast(message: Strings.couldNotLaunchSupportEmail);
    return false;
  }

  try {
    if (!await canLaunchUrl(uri)) {
      debugPrint("🔴 EMAIL LAUNCH: cannot launch $uri");
      showCustomErrorToast(message: Strings.couldNotLaunchSupportEmail);
      return false;
    }

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      showCustomErrorToast(message: Strings.couldNotLaunchSupportEmail);
    }
    return launched;
  } catch (error) {
    debugPrint("🔴 EMAIL LAUNCH ERROR: $error");
    showCustomErrorToast(message: Strings.couldNotLaunchSupportEmail);
    return false;
  }
}

Uri? buildSupportEmailUri(String email) {
  final cleaned = email.trim();
  return cleaned.isEmpty ? null : Uri(scheme: 'mailto', path: cleaned);
}

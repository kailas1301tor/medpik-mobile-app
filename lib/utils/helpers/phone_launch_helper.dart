// lib/utils/helpers/phone_launch_helper.dart
import 'package:flutter/material.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/utils/helpers/toast_helper.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> launchPhoneCall(String phoneNumber) async {
  final cleaned = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
  if (cleaned.isEmpty) {
    showCustomErrorToast(message: Strings.couldNotLaunchPhoneCall);
    return false;
  }

  final uri = Uri(scheme: 'tel', path: cleaned);

  try {
    if (!await canLaunchUrl(uri)) {
      debugPrint("🔴 PHONE LAUNCH: cannot launch $uri");
      showCustomErrorToast(message: Strings.couldNotLaunchPhoneCall);
      return false;
    }

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      showCustomErrorToast(message: Strings.couldNotLaunchPhoneCall);
    }

    return launched;
  } catch (error) {
    debugPrint("🔴 PHONE LAUNCH ERROR: $error");
    showCustomErrorToast(message: Strings.couldNotLaunchPhoneCall);
    return false;
  }
}

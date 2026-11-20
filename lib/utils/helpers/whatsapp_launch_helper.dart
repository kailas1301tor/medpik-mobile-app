// lib/utils/helpers/whatsapp_launch_helper.dart
import 'package:flutter/material.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/utils/helpers/toast_helper.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> launchWhatsAppChat(String phoneNumber, {String? message}) async {
  final uri = buildWhatsAppUri(phoneNumber, message: message);
  if (uri == null) {
    showCustomErrorToast(message: Strings.couldNotLaunchWhatsApp);
    return false;
  }

  try {
    if (!await canLaunchUrl(uri)) {
      debugPrint('🔴 WHATSAPP LAUNCH: cannot launch $uri');
      showCustomErrorToast(message: Strings.couldNotLaunchWhatsApp);
      return false;
    }

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      showCustomErrorToast(message: Strings.couldNotLaunchWhatsApp);
    }
    return launched;
  } catch (error) {
    debugPrint('🔴 WHATSAPP LAUNCH ERROR: $error');
    showCustomErrorToast(message: Strings.couldNotLaunchWhatsApp);
    return false;
  }
}

/// Builds `https://wa.me/<digits>` with optional prefilled [message].
Uri? buildWhatsAppUri(String phoneNumber, {String? message}) {
  final digits = phoneNumber.replaceAll(RegExp(r'\D'), '');
  if (digits.isEmpty) return null;

  final trimmedMessage = message?.trim() ?? '';
  if (trimmedMessage.isEmpty) {
    return Uri.https('wa.me', '/$digits');
  }
  return Uri.https('wa.me', '/$digits', {'text': trimmedMessage});
}

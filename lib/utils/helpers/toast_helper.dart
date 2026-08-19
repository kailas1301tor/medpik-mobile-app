import 'package:flutter/foundation.dart';
import 'package:medpik/utils/common_widgets/custom_toast.dart' as custom_toast;

/// Show a standard toast message.
void showCustomToast({
  required String message,
  bool? isSuccess,
  Duration? duration,
  String? link,
  VoidCallback? onTap,
  bool? increaseBottomPadding,
}) {
  custom_toast.showCustomToast(
    message: message,
    isSuccess: isSuccess,
    duration: duration,
    link: link,
    onTap: onTap,
    increaseBottomPadding: increaseBottomPadding,
  );
}

/// Show a standard error toast message.
void showCustomErrorToast({required String message}) {
  custom_toast.showCustomToast(message: message, isSuccess: false);
}

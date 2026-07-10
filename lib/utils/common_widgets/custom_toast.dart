import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import 'custom_toast_widget.dart';

void showCustomToast({
  required String message,
  bool? isSuccess,
  Duration? duration,
  String? link,
  VoidCallback? onTap,
  bool? increaseBottomPadding,
}) {
  toastification.dismissAll();

  toastification.showCustom(
    autoCloseDuration: duration ?? const Duration(seconds: 3),
    alignment: Alignment.bottomCenter,
    builder: (BuildContext context, ToastificationItem holder) {
      return CustomToastWidget(
        message: message,
        isSuccess: isSuccess,
        link: link,
        onLinkTap: onTap,
        increaseBottomPadding: increaseBottomPadding,
      );
    },
  );
}

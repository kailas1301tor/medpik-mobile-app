import 'package:medpik/utils/common_widgets/custom_toast.dart' as custom_toast;

/// Show a standard toast message.
void showCustomToast({required String message, bool? isSuccess}) {
  custom_toast.showCustomToast(message: message, isSuccess: isSuccess);
}

/// Show a standard error toast message.
void showCustomErrorToast({required String message}) {
  custom_toast.showCustomToast(message: message, isSuccess: false);
}

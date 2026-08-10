// lib/utils/helpers/otp_resend_guard.dart
bool canResendOtp({
  required String phone,
  required bool isResendingOtp,
  required bool isRequestingOtp,
  required bool isVerifyingOtp,
  required int resendCountdown,
}) {
  if (phone.trim().isEmpty) return false;
  if (isResendingOtp || isRequestingOtp || isVerifyingOtp) return false;
  if (resendCountdown > 0) return false;
  return true;
}

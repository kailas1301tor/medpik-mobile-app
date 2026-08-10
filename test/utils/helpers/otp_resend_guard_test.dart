// test/utils/helpers/otp_resend_guard_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/utils/helpers/otp_resend_guard.dart';

void main() {
  group('canResendOtp', () {
    test('returns false when phone is empty', () {
      expect(
        canResendOtp(
          phone: '',
          isResendingOtp: false,
          isRequestingOtp: false,
          isVerifyingOtp: false,
          resendCountdown: 0,
        ),
        isFalse,
      );
    });

    test('returns false when countdown is active', () {
      expect(
        canResendOtp(
          phone: '9876543210',
          isResendingOtp: false,
          isRequestingOtp: false,
          isVerifyingOtp: false,
          resendCountdown: 30,
        ),
        isFalse,
      );
    });

    test('returns false when already resending', () {
      expect(
        canResendOtp(
          phone: '9876543210',
          isResendingOtp: true,
          isRequestingOtp: false,
          isVerifyingOtp: false,
          resendCountdown: 0,
        ),
        isFalse,
      );
    });

    test('returns false when requesting OTP', () {
      expect(
        canResendOtp(
          phone: '9876543210',
          isResendingOtp: false,
          isRequestingOtp: true,
          isVerifyingOtp: false,
          resendCountdown: 0,
        ),
        isFalse,
      );
    });

    test('returns false when verifying OTP', () {
      expect(
        canResendOtp(
          phone: '9876543210',
          isResendingOtp: false,
          isRequestingOtp: false,
          isVerifyingOtp: true,
          resendCountdown: 0,
        ),
        isFalse,
      );
    });

    test('returns true when all guards pass', () {
      expect(
        canResendOtp(
          phone: '9876543210',
          isResendingOtp: false,
          isRequestingOtp: false,
          isVerifyingOtp: false,
          resendCountdown: 0,
        ),
        isTrue,
      );
    });
  });
}

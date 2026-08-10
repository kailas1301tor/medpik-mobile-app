// test/src/auth/notifier/auth_resend_notifier_test.dart
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/data/remote/network_base_services.dart';
import 'package:medpik/res/constants/app_constants.dart';
import 'package:medpik/services/repo_di.dart';
import 'package:medpik/src/auth/model/auth_model.dart';
import 'package:medpik/src/auth/model/verify_otp_response_model.dart';
import 'package:medpik/src/auth/notifier/auth_notifier.dart';
import 'package:medpik/src/auth/repo/auth_repo.dart';

class FakeAuthRepo implements AuthRepo {
  int resendCallCount = 0;
  Either<ResponseError, CommonResponseModel>? resendResult;

  @override
  Future<Either<ResponseError, CommonResponseModel>> requestOtp({
    required String phone,
    String countryCode = AppConstants.defaultCountryCode,
  }) async {
    await Future<void>.delayed(Duration.zero);
    return Right(CommonResponseModel(message: 'OTP sent'));
  }

  @override
  Future<Either<ResponseError, CommonResponseModel>> resendOtp({
    required String phone,
    String countryCode = AppConstants.defaultCountryCode,
  }) async {
    resendCallCount++;
    await Future<void>.delayed(Duration.zero);
    return resendResult ?? Right(CommonResponseModel(message: 'OTP resent'));
  }

  @override
  Future<Either<ResponseError, VerifyOtpResponse>> verifyOtp({
    required String phone,
    required String otp,
    String countryCode = AppConstants.defaultCountryCode,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<ResponseError, CommonResponseModel>> logout({
    required String refresh,
  }) {
    throw UnimplementedError();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthNotifier resend flow', () {
    late ProviderContainer container;
    late FakeAuthRepo fakeRepo;

    setUp(() {
      fakeRepo = FakeAuthRepo();
      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      );
    });

    tearDown(() => container.dispose());

    AuthNotifier readNotifier() =>
        container.read(authNotifierProvider.notifier);

    test('startResendTimer sets countdown to otpResendDuration', () {
      readNotifier().startResendTimer();

      expect(
        container.read(authNotifierProvider).resendCountdown,
        AppConstants.otpResendDuration,
      );
    });

    test('resendOtp skips API when countdown is active', () async {
      final notifier = readNotifier();
      notifier.state = notifier.state.copyWith(otpPhone: '9876543210');
      await notifier.startResendTimer();

      fakeRepo.resendCallCount = 0;
      await notifier.resendOtp();

      expect(fakeRepo.resendCallCount, 0);
    });
  });
}

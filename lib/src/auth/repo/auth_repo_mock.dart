// lib/src/auth/repo/auth_repo_mock.dart
import 'package:either_dart/either.dart';
import 'package:tsuite/data/mock/mock_users.dart';
import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/src/auth/model/auth_model.dart';
import 'package:tsuite/src/auth/repo/auth_repo.dart';

class AuthRepoMock implements AuthRepo {
  @override
  Future<Either<ResponseError, AuthModel>> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Right(MockUsers.activeUser(phone: '9876543210'));
  }

  @override
  Future<Either<ResponseError, AuthModel>> loginWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Right(MockUsers.activeUser(phone: '9876543210'));
  }

  @override
  Future<Either<ResponseError, AuthModel>> loginWithPhone({
    required String phone,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Right(MockUsers.activeUser(phone: phone));
  }

  @override
  Future<Either<ResponseError, CommonResponseModel>> requestOtp({
    required String phone,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (phone.length != 10) {
      return const Left(
        ResponseError(
          key: ApiErrorTypes.badRequest,
          message: Strings.invalidPhone,
        ),
      );
    }
    return Right(
      CommonResponseModel(status: true, message: Strings.otpSentSuccess),
    );
  }

  @override
  Future<Either<ResponseError, CommonResponseModel>> resendOtp({
    required String phone,
  }) async {
    return requestOtp(phone: phone);
  }

  @override
  Future<Either<ResponseError, AuthModel>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (otp.length != 6) {
      return const Left(
        ResponseError(
          key: ApiErrorTypes.badRequest,
          message: Strings.otpVerificationFailed,
        ),
      );
    }
    if (MockUsers.isSuspendedPhone(phone)) {
      return const Left(
        ResponseError(
          key: ApiErrorTypes.badRequest,
          message: Strings.accountSuspended,
        ),
      );
    }
    if (otp != MockUsers.validOtp) {
      return const Left(
        ResponseError(
          key: ApiErrorTypes.badRequest,
          message: Strings.otpVerificationFailed,
        ),
      );
    }
    return Right(MockUsers.activeUser(phone: phone));
  }

  @override
  Future<Either<ResponseError, CommonResponseModel>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const Right(
      CommonResponseModel(status: true, message: 'Registration successful'),
    );
  }

  @override
  Future<Either<ResponseError, CommonResponseModel>> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const Right(
      CommonResponseModel(status: true, message: 'Logged out'),
    );
  }
}

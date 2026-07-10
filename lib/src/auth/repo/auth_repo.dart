// lib/src/auth/repo/auth_repo.dart
import 'package:either_dart/either.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/data/remote/network_services.dart';
import 'package:tsuite/res/constants/app_constants.dart';
import 'package:tsuite/src/auth/model/auth_model.dart';

/// Abstract repository for authentication operations.
abstract class AuthRepo {
  Future<Either<ResponseError, AuthModel>> login({
    required String email,
    required String password,
  });

  Future<Either<ResponseError, AuthModel>> loginWithGoogle();

  Future<Either<ResponseError, AuthModel>> loginWithPhone({
    required String phone,
    required String password,
  });

  Future<Either<ResponseError, CommonResponseModel>> requestOtp({
    required String phone,
  });

  Future<Either<ResponseError, CommonResponseModel>> resendOtp({
    required String phone,
  });

  Future<Either<ResponseError, AuthModel>> verifyOtp({
    required String phone,
    required String otp,
  });

  Future<Either<ResponseError, CommonResponseModel>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<ResponseError, CommonResponseModel>> logout();
}

/// Concrete implementation of [AuthRepo].
class AuthRepoImpl implements AuthRepo {
  AuthRepoImpl(this._networkServices);

  final NetworkServices _networkServices;

  @override
  Future<Either<ResponseError, AuthModel>> login({
    required String email,
    required String password,
  }) async {
    return await _networkServices
        .safe(
          _networkServices.postRequest(
            endPoint: AppConstants.login,
            parameters: {'email': email, 'password': password},
            isFromAuth: true,
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight((right) => AuthModel.fromJson(right));
  }

  @override
  Future<Either<ResponseError, AuthModel>> loginWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return const Left(
          ResponseError(
            key: ApiErrorTypes.unknown,
            message: 'Google Sign-In was canceled',
          ),
        );
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken == null && accessToken == null) {
        return const Left(
          ResponseError(
            key: ApiErrorTypes.unknown,
            message: 'Failed to retrieve Google tokens',
          ),
        );
      }

      await Future.delayed(const Duration(seconds: 1));
      return Right(
        AuthModel(
          id: 0,
          email: googleUser.email,
          name: googleUser.displayName ?? 'Google User',
          phone: '',
          accessToken: 'dummy_access_token_from_google',
          refreshToken: 'dummy_refresh_token_from_google',
        ),
      );
    } catch (e) {
      return Left(
        ResponseError(
          key: ApiErrorTypes.unknown,
          message: 'Google Sign-In Error: $e',
        ),
      );
    }
  }

  @override
  Future<Either<ResponseError, AuthModel>> loginWithPhone({
    required String phone,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return Right(
      AuthModel(
        id: 1,
        email: 'mock@gym.com',
        name: 'Gym Member',
        phone: phone,
        accessToken: 'mock_token',
        refreshToken: 'mock_refresh',
      ),
    );
  }

  @override
  Future<Either<ResponseError, CommonResponseModel>> requestOtp({
    required String phone,
  }) async {
    return await _networkServices
        .safe(
          _networkServices.postRequest(
            endPoint: AppConstants.requestOtp,
            parameters: {'phone': phone},
            isFromAuth: true,
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight((right) => CommonResponseModel.fromJson(right));
  }

  @override
  Future<Either<ResponseError, CommonResponseModel>> resendOtp({
    required String phone,
  }) async {
    return await _networkServices
        .safe(
          _networkServices.postRequest(
            endPoint: AppConstants.resendOtp,
            parameters: {'phone': phone},
            isFromAuth: true,
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight((right) => CommonResponseModel.fromJson(right));
  }

  @override
  Future<Either<ResponseError, AuthModel>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    return await _networkServices
        .safe(
          _networkServices.postRequest(
            endPoint: AppConstants.verifyOtp,
            parameters: {'phone': phone, 'otp': otp},
            isFromAuth: true,
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight((right) => AuthModel.fromJson(right));
  }

  @override
  Future<Either<ResponseError, CommonResponseModel>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _networkServices
        .safe(
          _networkServices.postRequest(
            endPoint: AppConstants.register,
            parameters: {'name': name, 'email': email, 'password': password},
            isFromAuth: true,
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight((right) => CommonResponseModel.fromJson(right));
  }

  @override
  Future<Either<ResponseError, CommonResponseModel>> logout() async {
    return await _networkServices
        .safe(_networkServices.postRequest(endPoint: AppConstants.logout))
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight((right) => CommonResponseModel.fromJson(right));
  }
}

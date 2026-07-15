// lib/src/auth/repo/auth_repo.dart
import 'package:either_dart/either.dart';
import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/data/remote/network_services.dart';
import 'package:tsuite/res/constants/app_constants.dart';
import 'package:tsuite/src/auth/model/auth_model.dart';
import 'package:tsuite/utils/helpers/safe_converters.dart';

/// Abstract repository for authentication operations.
abstract class AuthRepo {
  Future<Either<ResponseError, CommonResponseModel>> requestOtp({
    required String phone,
    String countryCode = AppConstants.defaultCountryCode,
  });

  Future<Either<ResponseError, CommonResponseModel>> resendOtp({
    required String phone,
    String countryCode = AppConstants.defaultCountryCode,
  });

  Future<Either<ResponseError, VerifyOtpResult>> verifyOtp({
    required String phone,
    required String otp,
    String countryCode = AppConstants.defaultCountryCode,
  });

  Future<Either<ResponseError, CommonResponseModel>> logout();
}

/// Concrete implementation of [AuthRepo].
class AuthRepoImpl implements AuthRepo {
  AuthRepoImpl(this._networkServices);

  final NetworkServices _networkServices;

  @override
  Future<Either<ResponseError, CommonResponseModel>> requestOtp({
    required String phone,
    String countryCode = AppConstants.defaultCountryCode,
  }) async {
    return await _networkServices
        .safe(
          _networkServices.postRequest(
            endPoint: AppConstants.requestOtp,
            parameters: {
              'country_code': countryCode,
              'phone_number': phone,
            },
            isFromAuth: true,
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight((right) => CommonResponseModel.fromJson(convertToMap(right)));
  }

  @override
  Future<Either<ResponseError, CommonResponseModel>> resendOtp({
    required String phone,
    String countryCode = AppConstants.defaultCountryCode,
  }) async {
    return requestOtp(phone: phone, countryCode: countryCode);
  }

  @override
  Future<Either<ResponseError, VerifyOtpResult>> verifyOtp({
    required String phone,
    required String otp,
    String countryCode = AppConstants.defaultCountryCode,
  }) async {
    return await _networkServices
        .safe(
          _networkServices.postRequest(
            endPoint: AppConstants.verifyOtp,
            parameters: {
              'country_code': countryCode,
              'phone_number': phone,
              'otp': otp,
            },
            isFromAuth: true,
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight((right) => VerifyOtpResult.fromApiJson(convertToMap(right)));
  }

  @override
  Future<Either<ResponseError, CommonResponseModel>> logout() async {
    return await _networkServices
        .safe(_networkServices.postRequest(endPoint: AppConstants.logout))
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight((right) {
          if (right is Map) {
            return CommonResponseModel.fromJson(convertToMap(right));
          }
          return const CommonResponseModel(message: 'Logged out');
        });
  }
}

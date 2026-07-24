// lib/src/auth/repo/auth_repo.dart
import 'package:either_dart/either.dart';
import 'package:medpik/data/remote/network_base_services.dart';
import 'package:medpik/data/remote/network_services.dart';
import 'package:medpik/res/constants/app_constants.dart';
import 'package:medpik/src/auth/model/auth_model.dart';
import 'package:medpik/src/auth/model/verify_otp_response_model.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';

abstract class AuthRepo {
  Future<Either<ResponseError, CommonResponseModel>> requestOtp({
    required String phone,
    String countryCode = AppConstants.defaultCountryCode,
  });

  Future<Either<ResponseError, CommonResponseModel>> resendOtp({
    required String phone,
    String countryCode = AppConstants.defaultCountryCode,
  });

  Future<Either<ResponseError, VerifyOtpResponse>> verifyOtp({
    required String phone,
    required String otp,
    String countryCode = AppConstants.defaultCountryCode,
  });

  Future<Either<ResponseError, CommonResponseModel>> logout({
    required String refresh,
  });
}

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
  Future<Either<ResponseError, VerifyOtpResponse>> verifyOtp({
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
        .mapRight((right) => VerifyOtpResponse.fromJson(convertToMap(right)));
  }

  @override
  Future<Either<ResponseError, CommonResponseModel>> logout({
    required String refresh,
  }) async {
    return await _networkServices
        .safe(
          _networkServices.postRequest(
            endPoint: AppConstants.logout,
            parameters: {'refresh': refresh},
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight((right) => CommonResponseModel.fromJson(convertToMap(right)));
  }
}

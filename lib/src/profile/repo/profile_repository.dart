// lib/src/profile/repo/profile_repository.dart
import 'package:either_dart/either.dart';
import 'package:medpik/data/remote/network_base_services.dart';
import 'package:medpik/data/remote/network_services.dart';
import 'package:medpik/res/constants/app_constants.dart';
import 'package:medpik/src/profile/model/profile_model.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';

abstract class ProfileRepo {
  Future<Either<ResponseError, ProfileResponse>> getProfile();

  Future<Either<ResponseError, ProfileResponse>> updateProfile(
    ProfileModel profile,
  );
}

class ProfileRepoImpl implements ProfileRepo {
  ProfileRepoImpl(this._networkServices);

  final NetworkServices _networkServices;

  @override
  Future<Either<ResponseError, ProfileResponse>> getProfile() async {
    return await _networkServices
        .safe(
          _networkServices.getRequest(endPoint: AppConstants.customerProfile),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight(
          (right) => ProfileResponse.fromJson(convertToMap(right)),
        );
  }

  @override
  Future<Either<ResponseError, ProfileResponse>> updateProfile(
    ProfileModel profile,
  ) async {
    return await _networkServices
        .safe(
          _networkServices.putRequest(
            endPoint: AppConstants.customerProfile,
            parameters: profile.toUpdateJson(),
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight(
          (right) => ProfileResponse.fromJson(convertToMap(right)),
        );
  }
}

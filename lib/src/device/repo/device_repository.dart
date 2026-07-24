// lib/src/device/repo/device_repository.dart
import 'package:either_dart/either.dart';
import 'package:medpik/data/remote/network_base_services.dart';
import 'package:medpik/data/remote/network_services.dart';
import 'package:medpik/res/constants/app_constants.dart';
import 'package:medpik/src/auth/model/auth_model.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';

abstract class DeviceRepo {
  Future<Either<ResponseError, CommonResponseModel>> registerDevice({
    required String subscriptionId,
    required String platform,
  });
}

class DeviceRepoImpl implements DeviceRepo {
  DeviceRepoImpl(this._networkServices);

  final NetworkServices _networkServices;

  @override
  Future<Either<ResponseError, CommonResponseModel>> registerDevice({
    required String subscriptionId,
    required String platform,
  }) async {
    return await _networkServices
        .safe(
          _networkServices.postRequest(
            endPoint: AppConstants.devicesRegister,
            parameters: {
              'subscription_id': subscriptionId,
              'platform': platform,
            },
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight((right) => CommonResponseModel.fromJson(convertToMap(right)));
  }
}

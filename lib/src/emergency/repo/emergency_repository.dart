// lib/src/emergency/repo/emergency_repository.dart
import 'package:either_dart/either.dart';
import 'package:medpik/data/remote/network_base_services.dart';
import 'package:medpik/data/remote/network_services.dart';
import 'package:medpik/res/constants/app_constants.dart';
import 'package:medpik/src/emergency/model/emergency_services_model.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';

abstract class EmergencyRepo {
  Future<Either<ResponseError, EmergencyServicesResponse>>
      getEmergencyServices();
}

class EmergencyRepoImpl implements EmergencyRepo {
  EmergencyRepoImpl(this._networkServices);

  final NetworkServices _networkServices;

  @override
  Future<Either<ResponseError, EmergencyServicesResponse>>
      getEmergencyServices() async {
    return await _networkServices
        .safe(
          _networkServices.getRequest(
            endPoint: AppConstants.emergencyServices,
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight(
          (right) => EmergencyServicesResponse.fromJson(convertToMap(right)),
        );
  }
}

// lib/src/home/repo/home_repository.dart
import 'package:either_dart/either.dart';
import 'package:medpik/data/remote/network_base_services.dart';
import 'package:medpik/data/remote/network_services.dart';
import 'package:medpik/res/constants/app_constants.dart';
import 'package:medpik/src/home/model/customer_general_data_model.dart';
import 'package:medpik/src/home/model/home_model.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';

abstract class HomeRepo {
  Future<Either<ResponseError, HomeFeedModel>> getHomeFeed();
  Future<Either<ResponseError, CustomerGeneralDataResponse>>
      getCustomerGeneralData();
}

class HomeRepoImpl implements HomeRepo {
  HomeRepoImpl(this._networkServices);

  final NetworkServices _networkServices;

  @override
  Future<Either<ResponseError, HomeFeedModel>> getHomeFeed() async {
    return await _networkServices
        .safe(_networkServices.getRequest(endPoint: AppConstants.homeFeed))
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight((right) => HomeFeedModel.fromJson(convertToMap(right)));
  }

  @override
  Future<Either<ResponseError, CustomerGeneralDataResponse>>
      getCustomerGeneralData() async {
    return await _networkServices
        .safe(
          _networkServices.getRequest(
            endPoint: AppConstants.customerGeneralData,
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight(
          (right) => CustomerGeneralDataResponse.fromJson(convertToMap(right)),
        );
  }
}

// lib/src/home/repo/home_repository.dart
import 'package:either_dart/either.dart';
import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/data/remote/network_services.dart';
import 'package:tsuite/res/constants/app_constants.dart';
import 'package:tsuite/src/home/model/home_model.dart';
import 'package:tsuite/utils/helpers/safe_converters.dart';

abstract class HomeRepo {
  Future<Either<ResponseError, HomeFeedModel>> getHomeFeed();
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
}

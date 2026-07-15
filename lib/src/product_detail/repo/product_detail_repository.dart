// lib/src/product_detail/repo/product_detail_repository.dart
import 'package:either_dart/either.dart';
import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/data/remote/network_services.dart';
import 'package:tsuite/res/constants/app_constants.dart';
import 'package:tsuite/src/product_detail/model/product_detail_model.dart';
import 'package:tsuite/utils/helpers/safe_converters.dart';

abstract class ProductDetailRepo {
  Future<Either<ResponseError, ProductDetailResponse>> getProductById(int id);
}

class ProductDetailRepoImpl implements ProductDetailRepo {
  ProductDetailRepoImpl(this._networkServices);

  final NetworkServices _networkServices;

  @override
  Future<Either<ResponseError, ProductDetailResponse>> getProductById(
    int id,
  ) async {
    return await _networkServices
        .safe(
          _networkServices.getRequest(
            endPoint: AppConstants.customerProductDetail,
            queryParameters: {'product_id': id},
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight(
          (right) => ProductDetailResponse.fromJson(convertToMap(right)),
        );
  }
}

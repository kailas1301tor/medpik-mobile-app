// lib/src/product_detail/repo/product_detail_repository.dart
import 'package:either_dart/either.dart';
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/data/remote/network_services.dart';
import 'package:tsuite/res/constants/app_constants.dart';
import 'package:tsuite/utils/helpers/safe_converters.dart';

abstract class ProductDetailRepo {
  Future<Either<ResponseError, ProductModel>> getProductById(int id);
}

class ProductDetailRepoImpl implements ProductDetailRepo {
  ProductDetailRepoImpl(this._networkServices);

  final NetworkServices _networkServices;

  @override
  Future<Either<ResponseError, ProductModel>> getProductById(int id) async {
    return await _networkServices
        .safe(
          _networkServices.getRequest(
            endPoint: '${AppConstants.products}/$id',
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight((right) => ProductModel.fromJson(convertToMap(right)));
  }
}

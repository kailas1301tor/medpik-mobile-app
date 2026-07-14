// lib/src/product_detail/repo/product_detail_repository.dart
import 'package:either_dart/either.dart';
import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/data/remote/network_services.dart';
import 'package:tsuite/res/constants/app_constants.dart';
import 'package:tsuite/src/product_detail/model/product_detail_model.dart';
import 'package:tsuite/src/product_detail/repo/product_detail_data_builder.dart';
import 'package:tsuite/utils/helpers/safe_converters.dart';
import 'package:tsuite/data/models/product_model.dart';

abstract class ProductDetailRepo {
  Future<Either<ResponseError, ProductDetailModel>> getProductById(int id);
}

class ProductDetailRepoImpl implements ProductDetailRepo {
  ProductDetailRepoImpl(this._networkServices);

  final NetworkServices _networkServices;

  @override
  Future<Either<ResponseError, ProductDetailModel>> getProductById(int id) async {
    return await _networkServices
        .safe(
          _networkServices.getRequest(
            endPoint: '${AppConstants.products}/$id',
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight((right) {
          final product = ProductModel.fromJson(convertToMap(right));
          return ProductDetailDataBuilder.build(product);
        });
  }
}

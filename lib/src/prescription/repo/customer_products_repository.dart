// lib/src/prescription/repo/customer_products_repository.dart
import 'package:either_dart/either.dart';
import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/data/remote/network_services.dart';
import 'package:tsuite/res/constants/app_constants.dart';
import 'package:tsuite/src/prescription/model/customer_products_model.dart';
import 'package:tsuite/utils/helpers/safe_converters.dart';

abstract class CustomerProductsRepo {
  Future<Either<ResponseError, CustomerProductsResponse>> getCustomerProducts({
    required String search,
    required int page,
    int pageSize = 10,
  });
}

class CustomerProductsRepoImpl implements CustomerProductsRepo {
  CustomerProductsRepoImpl(this._networkServices);

  final NetworkServices _networkServices;

  @override
  Future<Either<ResponseError, CustomerProductsResponse>> getCustomerProducts({
    required String search,
    required int page,
    int pageSize = 10,
  }) async {
    return await _networkServices
        .safe(
          _networkServices.getRequest(
            endPoint: AppConstants.customerProducts,
            queryParameters: {
              'search': search,
              'page': page,
              'page_size': pageSize,
            },
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight(
          (right) => CustomerProductsResponse.fromJson(convertToMap(right)),
        );
  }
}

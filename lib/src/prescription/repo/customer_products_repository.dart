// lib/src/prescription/repo/customer_products_repository.dart
import 'package:either_dart/either.dart';
import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/data/remote/network_services.dart';
import 'package:tsuite/res/constants/app_constants.dart';
import 'package:tsuite/src/prescription/model/customer_products_model.dart';
import 'package:tsuite/utils/helpers/safe_converters.dart';

abstract class CustomerProductsRepo {
  Future<Either<ResponseError, CustomerProductsResponse>> getCustomerProducts({
    String search = '',
    int? categoryId,
    int? offerId,
    required int page,
    int pageSize = 10,
  });
}

class CustomerProductsRepoImpl implements CustomerProductsRepo {
  CustomerProductsRepoImpl(this._networkServices);

  final NetworkServices _networkServices;

  @override
  Future<Either<ResponseError, CustomerProductsResponse>> getCustomerProducts({
    String search = '',
    int? categoryId,
    int? offerId,
    required int page,
    int pageSize = 10,
  }) async {
    final queryParameters = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
    };
    final trimmedSearch = search.trim();
    if (trimmedSearch.isNotEmpty) {
      queryParameters['search'] = trimmedSearch;
    }
    if (categoryId != null) {
      queryParameters['category_id'] = categoryId;
    }
    if (offerId != null) {
      queryParameters['offer_id'] = offerId;
    }

    return await _networkServices
        .safe(
          _networkServices.getRequest(
            endPoint: AppConstants.customerProducts,
            queryParameters: queryParameters,
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight(
          (right) => CustomerProductsResponse.fromJson(convertToMap(right)),
        );
  }
}

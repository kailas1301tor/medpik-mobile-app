// lib/src/search/repo/search_repository.dart
import 'package:either_dart/either.dart';
import 'package:medpik/data/remote/network_base_services.dart';
import 'package:medpik/data/remote/network_services.dart';
import 'package:medpik/res/constants/app_constants.dart';
import 'package:medpik/src/search/model/search_catalog_model.dart';
import 'package:medpik/utils/helpers/recent_search_helper.dart' as recent_helper;
import 'package:medpik/utils/helpers/safe_converters.dart';

abstract class SearchRepo {
  Future<Either<ResponseError, SearchCatalogResponse>> getCatalogProducts({
    String search = '',
    int? categoryId,
    int? offerId,
    required int page,
    int pageSize = 10,
  });

  Future<Either<ResponseError, bool>> saveRecentSearch(String query);
}

class SearchRepoImpl implements SearchRepo {
  SearchRepoImpl(this._networkServices);

  final NetworkServices _networkServices;

  @override
  Future<Either<ResponseError, SearchCatalogResponse>> getCatalogProducts({
    String search = '',
    int? categoryId,
    int? offerId,
    required int page,
    int pageSize = 9,
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
          (right) => SearchCatalogResponse.fromJson(convertToMap(right)),
        );
  }

  @override
  Future<Either<ResponseError, bool>> saveRecentSearch(String query) async {
    try {
      await recent_helper.addRecentSearch(query);
      return const Right(true);
    } catch (error) {
      return Left(
        ResponseError(
          key: ApiErrorTypes.oops,
          message: error.toString(),
        ),
      );
    }
  }
}

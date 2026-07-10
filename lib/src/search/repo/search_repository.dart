// lib/src/search/repo/search_repository.dart
import 'package:either_dart/either.dart';
import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/data/remote/network_services.dart';
import 'package:tsuite/res/constants/app_constants.dart';
import 'package:tsuite/src/search/model/search_model.dart';

abstract class SearchRepo {
  Future<Either<ResponseError, SearchResponseModel>> searchProducts({
    required String query,
    String? category,
  });

  Future<Either<ResponseError, List<String>>> getRecentSearches();

  Future<Either<ResponseError, bool>> saveRecentSearch(String query);
}

class SearchRepoImpl implements SearchRepo {
  SearchRepoImpl(this._networkServices);

  final NetworkServices _networkServices;

  @override
  Future<Either<ResponseError, SearchResponseModel>> searchProducts({
    required String query,
    String? category,
  }) async {
    return await _networkServices
        .safe(
          _networkServices.getRequest(
            endPoint: AppConstants.products,
            queryParameters: {
              'q': query,
              if (category != null && category.isNotEmpty) 'category': category,
            },
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight((right) => SearchResponseModel.fromJson(right));
  }

  @override
  Future<Either<ResponseError, List<String>>> getRecentSearches() async {
    return const Left(
      ResponseError(
        key: ApiErrorTypes.oops,
        message: 'Not implemented',
      ),
    );
  }

  @override
  Future<Either<ResponseError, bool>> saveRecentSearch(String query) async {
    return const Left(
      ResponseError(
        key: ApiErrorTypes.oops,
        message: 'Not implemented',
      ),
    );
  }
}

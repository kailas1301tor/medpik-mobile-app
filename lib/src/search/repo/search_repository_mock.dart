// lib/src/search/repo/search_repository_mock.dart
import 'package:either_dart/either.dart';
import 'package:tsuite/data/mock/mock_catalog.dart';
import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/src/search/model/search_model.dart';
import 'package:tsuite/src/search/repo/search_repository.dart';
import 'package:tsuite/utils/helpers/recent_search_helper.dart' as recent_helper;

class SearchRepoMock implements SearchRepo {
  @override
  Future<Either<ResponseError, SearchResponseModel>> searchProducts({
    required String query,
    String? category,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final products = MockCatalog.searchProducts(
      query: query,
      category: category,
    );
    return Right(
      SearchResponseModel(
        products: products,
        categories: MockCatalog.categories,
      ),
    );
  }

  @override
  Future<Either<ResponseError, List<String>>> getRecentSearches() async {
    final recent = await recent_helper.getRecentSearches();
    return Right(recent);
  }

  @override
  Future<Either<ResponseError, bool>> saveRecentSearch(String query) async {
    await recent_helper.addRecentSearch(query);
    return const Right(true);
  }
}

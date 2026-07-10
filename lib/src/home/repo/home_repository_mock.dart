// lib/src/home/repo/home_repository_mock.dart
import 'package:either_dart/either.dart';
import 'package:tsuite/data/mock/mock_catalog.dart';
import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/src/home/model/home_model.dart';
import 'package:tsuite/src/home/repo/home_repository.dart';

class HomeRepoMock implements HomeRepo {
  @override
  Future<Either<ResponseError, HomeFeedModel>> getHomeFeed() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return Right(
      HomeFeedModel(
        userName: 'Anumodh',
        deliveryHint: MockCatalog.defaultDeliveryHint,
        categories: MockCatalog.categories,
        offers: MockCatalog.offers,
        featuredProducts: MockCatalog.featuredProducts,
      ),
    );
  }
}

// lib/src/product_detail/repo/product_detail_repository_mock.dart
import 'package:either_dart/either.dart';
import 'package:tsuite/data/mock/mock_catalog.dart';
import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/src/product_detail/model/product_detail_model.dart';
import 'package:tsuite/src/product_detail/repo/product_detail_data_builder.dart';
import 'package:tsuite/src/product_detail/repo/product_detail_repository.dart';

class ProductDetailRepoMock implements ProductDetailRepo {
  @override
  Future<Either<ResponseError, ProductDetailModel>> getProductById(int id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final product = MockCatalog.productById(id);
    if (product == null) {
      return const Left(
        ResponseError(
          key: ApiErrorTypes.notFound,
          message: Strings.noDataFound,
        ),
      );
    }
    return Right(ProductDetailDataBuilder.build(product));
  }
}

// lib/src/cart/repo/cart_repository.dart
import 'package:either_dart/either.dart';
import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/data/remote/network_services.dart';
import 'package:tsuite/res/constants/app_constants.dart';
import 'package:tsuite/src/cart/model/cart_response_model.dart';
import 'package:tsuite/utils/helpers/safe_converters.dart';

abstract class CartRepo {
  Future<Either<ResponseError, CartResponse>> getCart();

  Future<Either<ResponseError, void>> addToCart({
    required int productId,
    required int quantity,
  });

  Future<Either<ResponseError, void>> removeCartItems({
    required List<int> itemIds,
  });
}

class CartRepoImpl implements CartRepo {
  CartRepoImpl(this._networkServices);

  final NetworkServices _networkServices;

  @override
  Future<Either<ResponseError, CartResponse>> getCart() async {
    return await _networkServices
        .safe(_networkServices.getRequest(endPoint: AppConstants.cart))
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight((right) => CartResponse.fromJson(convertToMap(right)));
  }

  @override
  Future<Either<ResponseError, void>> addToCart({
    required int productId,
    required int quantity,
  }) async {
    return await _networkServices
        .safe(
          _networkServices.postRequest(
            endPoint: AppConstants.cart,
            parameters: {
              'product_id': productId,
              'quantity': quantity,
            },
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight((_) {});
  }

  @override
  Future<Either<ResponseError, void>> removeCartItems({
    required List<int> itemIds,
  }) async {
    if (itemIds.isEmpty) {
      return const Right(null);
    }

    return await _networkServices
        .safe(
          _networkServices.deleteRequest(
            endPoint: AppConstants.cart,
            parameters: {
              'item_ids': itemIds,
            },
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight((_) {});
  }
}

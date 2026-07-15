// lib/src/wishlist/repo/wishlist_repository.dart
import 'package:either_dart/either.dart';
import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/data/remote/network_services.dart';
import 'package:tsuite/res/constants/app_constants.dart';
import 'package:tsuite/src/wishlist/model/wishlist_model.dart';
import 'package:tsuite/utils/helpers/safe_converters.dart';

abstract class WishlistRepo {
  Future<Either<ResponseError, WishlistResponse>> getWishlist();

  Future<Either<ResponseError, WishlistToggleResponse>> toggleWishlist({
    required int productId,
  });
}

class WishlistRepoImpl implements WishlistRepo {
  WishlistRepoImpl(this._networkServices);

  final NetworkServices _networkServices;

  @override
  Future<Either<ResponseError, WishlistResponse>> getWishlist() async {
    return await _networkServices
        .safe(_networkServices.getRequest(endPoint: AppConstants.wishlist))
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight((right) => WishlistResponse.fromJson(convertToMap(right)));
  }

  @override
  Future<Either<ResponseError, WishlistToggleResponse>> toggleWishlist({
    required int productId,
  }) async {
    return await _networkServices
        .safe(
          _networkServices.postRequest(
            endPoint: AppConstants.wishlist,
            parameters: {'product_id': productId},
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight(
          (right) => WishlistToggleResponse.fromJson(convertToMap(right)),
        );
  }
}

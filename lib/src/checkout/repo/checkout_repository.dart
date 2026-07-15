// lib/src/checkout/repo/checkout_repository.dart
import 'package:either_dart/either.dart';
import 'package:tsuite/data/models/address_model.dart';
import 'package:tsuite/data/models/order_model.dart';
import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/data/remote/network_services.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/src/cart/model/cart_item_model.dart';

abstract class CheckoutRepo {
  Future<Either<ResponseError, OrderModel>> placeOrder({
    required List<CartItemModel> items,
    required AddressModel address,
    required double amount,
  });
}

class CheckoutRepoImpl implements CheckoutRepo {
  CheckoutRepoImpl(this._networkServices);

  final NetworkServices _networkServices;

  @override
  Future<Either<ResponseError, OrderModel>> placeOrder({
    required List<CartItemModel> items,
    required AddressModel address,
    required double amount,
  }) async {
    _networkServices.hashCode;
    return const Left(
      ResponseError(
        key: ApiErrorTypes.oops,
        message: Strings.cartCheckoutUnavailable,
      ),
    );
  }
}

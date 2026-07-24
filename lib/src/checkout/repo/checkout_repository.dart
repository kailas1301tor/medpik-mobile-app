// lib/src/checkout/repo/checkout_repository.dart
import 'package:either_dart/either.dart';
import 'package:medpik/data/remote/network_base_services.dart';
import 'package:medpik/data/remote/network_services.dart';
import 'package:medpik/res/constants/app_constants.dart';
import 'package:medpik/src/checkout/model/cart_order_response_model.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';

abstract class CheckoutRepo {
  Future<Either<ResponseError, CartOrderResponse>> placeOrder({
    required int addressId,
    required String deliveryInstructions,
  });
}

class CheckoutRepoImpl implements CheckoutRepo {
  CheckoutRepoImpl(this._networkServices);

  final NetworkServices _networkServices;

  @override
  Future<Either<ResponseError, CartOrderResponse>> placeOrder({
    required int addressId,
    required String deliveryInstructions,
  }) async {
    return await _networkServices
        .safe(
          _networkServices.postRequest(
            endPoint: AppConstants.orders,
            parameters: {
              'source': 'cart',
              'address_id': addressId,
              'delivery_instructions': deliveryInstructions,
            },
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight((right) => CartOrderResponse.fromJson(convertToMap(right)));
  }
}

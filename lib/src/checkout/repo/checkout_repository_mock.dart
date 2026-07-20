// lib/src/checkout/repo/checkout_repository_mock.dart
import 'package:either_dart/either.dart';
import 'package:tsuite/data/mock/mock_store.dart';
import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/src/checkout/model/cart_order_response_model.dart';
import 'package:tsuite/src/checkout/repo/checkout_repository.dart';

class CheckoutRepoMock implements CheckoutRepo {
  final _store = MockStore.instance;

  @override
  Future<Either<ResponseError, CartOrderResponse>> placeOrder({
    required int addressId,
    required String deliveryInstructions,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final orderId = _store.nextOrderId();
    return Right(
      CartOrderResponse(
        message: 'Success',
        results: CartOrderResults(
          data: CartOrderData(orderId: orderId),
        ),
      ),
    );
  }
}

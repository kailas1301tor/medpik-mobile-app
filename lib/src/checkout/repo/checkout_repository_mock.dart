// lib/src/checkout/repo/checkout_repository_mock.dart
import 'package:either_dart/either.dart';
import 'package:tsuite/data/mock/mock_store.dart';
import 'package:tsuite/data/models/address_model.dart';
import 'package:tsuite/data/models/order_model.dart';
import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/src/cart/model/cart_item_model.dart';
import 'package:tsuite/src/checkout/repo/checkout_repository.dart';

class CheckoutRepoMock implements CheckoutRepo {
  final _store = MockStore.instance;

  @override
  Future<Either<ResponseError, OrderModel>> placeOrder({
    required List<CartItemModel> items,
    required AddressModel address,
    required double amount,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final orderItems = items
        .map(
          (item) => OrderItemModel(
            product: item.product,
            quantity: item.quantity,
          ),
        )
        .toList();

    final order = OrderModel(
      id: _store.nextOrderId(),
      items: orderItems,
      amount: amount,
      status: OrderStatus.orderConfirmed,
      address: address,
      createdAt: DateTime.now(),
      etaText: 'Arriving in 35 mins',
      hasPrescription: false,
    );

    _store.orders.insert(0, order);
    return Right(order);
  }
}

// lib/src/orders/repo/orders_repository_mock.dart
import 'package:either_dart/either.dart';
import 'package:tsuite/data/mock/mock_store.dart';
import 'package:tsuite/data/models/order_model.dart';
import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/src/orders/repo/orders_repository.dart';

class OrdersRepoMock implements OrdersRepo {
  final _store = MockStore.instance;

  @override
  Future<Either<ResponseError, List<OrderModel>>> getOrders() async {
    await Future.delayed(const Duration(milliseconds: 400));
    _store.seedDemoOrdersIfEmpty();
    return Right(List<OrderModel>.from(_store.orders));
  }

  @override
  Future<Either<ResponseError, OrderModel>> getOrderById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _store.seedDemoOrdersIfEmpty();
    for (final order in _store.orders) {
      if (order.id == id) return Right(order);
    }
    return const Left(
      ResponseError(
        key: ApiErrorTypes.notFound,
        message: Strings.noDataFound,
      ),
    );
  }
}

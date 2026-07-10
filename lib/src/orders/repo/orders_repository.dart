// lib/src/orders/repo/orders_repository.dart
import 'package:either_dart/either.dart';
import 'package:tsuite/data/models/order_model.dart';
import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/data/remote/network_services.dart';

abstract class OrdersRepo {
  Future<Either<ResponseError, List<OrderModel>>> getOrders();

  Future<Either<ResponseError, OrderModel>> getOrderById(String id);
}

class OrdersRepoImpl implements OrdersRepo {
  OrdersRepoImpl(this._networkServices);

  final NetworkServices _networkServices;

  @override
  Future<Either<ResponseError, List<OrderModel>>> getOrders() async {
    return const Left(
      ResponseError(key: ApiErrorTypes.oops, message: 'Not implemented'),
    );
  }

  @override
  Future<Either<ResponseError, OrderModel>> getOrderById(String id) async {
    return const Left(
      ResponseError(key: ApiErrorTypes.oops, message: 'Not implemented'),
    );
  }
}

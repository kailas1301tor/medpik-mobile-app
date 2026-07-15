// lib/src/orders/repo/orders_repository.dart
import 'package:either_dart/either.dart';
import 'package:tsuite/data/models/order_model.dart';
import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/data/remote/network_services.dart';
import 'package:tsuite/res/constants/app_constants.dart';
import 'package:tsuite/src/orders/model/orders_response_model.dart';
import 'package:tsuite/utils/helpers/safe_converters.dart';

abstract class OrdersRepo {
  Future<Either<ResponseError, List<OrderModel>>> getOrders();

  Future<Either<ResponseError, OrderModel>> getOrderById(String id);
}

class OrdersRepoImpl implements OrdersRepo {
  OrdersRepoImpl(this._networkServices);

  final NetworkServices _networkServices;

  @override
  Future<Either<ResponseError, List<OrderModel>>> getOrders() async {
    return await _networkServices
        .safe(_networkServices.getRequest(endPoint: AppConstants.orders))
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight(
          (right) => OrdersResponse.fromJson(convertToMap(right)).orders,
        );
  }

  @override
  Future<Either<ResponseError, OrderModel>> getOrderById(String id) async {
    return const Left(
      ResponseError(key: ApiErrorTypes.oops, message: 'Not implemented'),
    );
  }
}

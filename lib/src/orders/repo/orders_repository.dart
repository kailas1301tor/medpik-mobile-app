// lib/src/orders/repo/orders_repository.dart
import 'package:either_dart/either.dart';
import 'package:tsuite/data/models/order_model.dart';
import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/data/remote/network_services.dart';
import 'package:tsuite/res/constants/app_constants.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/src/orders/model/order_detail_response_model.dart';
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
    final trimmedId = id.trim();
    if (trimmedId.isEmpty) {
      return const Left(
        ResponseError(
          key: ApiErrorTypes.badRequest,
          message: Strings.somethingWentWrong,
        ),
      );
    }

    return await _networkServices
        .safe(
          _networkServices.getRequest(
            endPoint: AppConstants.orders,
            queryParameters: {'id': trimmedId},
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight(
          (right) => OrderDetailResponse.fromJson(convertToMap(right)),
        )
        .then((either) {
          return either.fold(
            (error) => Left(error),
            (response) {
              final order = response.order;
              if (order == null || order.id.isEmpty) {
                return const Left(
                  ResponseError(
                    key: ApiErrorTypes.jsonParsing,
                    message: Strings.somethingWentWrong,
                  ),
                );
              }
              return Right(order);
            },
          );
        });
  }
}

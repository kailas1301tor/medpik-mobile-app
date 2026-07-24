// lib/src/orders/repo/orders_repository.dart
import 'package:either_dart/either.dart';
import 'package:medpik/data/remote/network_base_services.dart';
import 'package:medpik/data/remote/network_services.dart';
import 'package:medpik/res/constants/app_constants.dart';
import 'package:medpik/src/orders/model/order_bill_action_response_model.dart';
import 'package:medpik/src/orders/model/order_detail_response_model.dart';
import 'package:medpik/src/orders/model/order_payment_create_response_model.dart';
import 'package:medpik/src/orders/model/order_payment_submit_response_model.dart';
import 'package:medpik/src/orders/model/orders_response_model.dart';
import 'package:medpik/utils/helpers/order_payment_request_helper.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';

abstract class OrdersRepo {
  Future<Either<ResponseError, OrdersResponse>> getOrders();

  Future<Either<ResponseError, OrderDetailResponse>> getOrderById(String id);

  Future<Either<ResponseError, OrderBillActionResponse>> submitBillAction({
    required int orderId,
    required String action,
    String? rejectReason,
  });

  Future<Either<ResponseError, OrderPaymentCreateResponse>> initPayment({
    required int orderId,
  });

  Future<Either<ResponseError, OrderPaymentSubmitResponse>> submitPayment({
    required Map<String, dynamic> body,
  });
}

class OrdersRepoImpl implements OrdersRepo {
  OrdersRepoImpl(this._networkServices);

  final NetworkServices _networkServices;

  @override
  Future<Either<ResponseError, OrdersResponse>> getOrders() async {
    return await _networkServices
        .safe(_networkServices.getRequest(endPoint: AppConstants.orders))
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight(
          (right) => OrdersResponse.fromJson(convertToMap(right)),
        );
  }

  @override
  Future<Either<ResponseError, OrderDetailResponse>> getOrderById(String id) async {
    return await _networkServices
        .safe(
          _networkServices.getRequest(
            endPoint: AppConstants.orders,
            queryParameters: {'id': id.trim()},
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight(
          (right) => OrderDetailResponse.fromJson(convertToMap(right)),
        );
  }

  @override
  Future<Either<ResponseError, OrderBillActionResponse>> submitBillAction({
    required int orderId,
    required String action,
    String? rejectReason,
  }) async {
    final body = <String, dynamic>{
      'order_id': orderId,
      'action': action,
    };

    if (action == 'reject') {
      final reason = rejectReason?.trim() ?? '';
      if (reason.isNotEmpty) {
        body['reject_reason'] = reason;
      }
    }

    return await _networkServices
        .safe(
          _networkServices.postRequest(
            endPoint: AppConstants.ordersBillAction,
            parameters: body,
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight(
          (right) => OrderBillActionResponse.fromJson(convertToMap(right)),
        );
  }

  @override
  Future<Either<ResponseError, OrderPaymentCreateResponse>> initPayment({
    required int orderId,
  }) async {
    return await _networkServices
        .safe(
          _networkServices.postRequest(
            endPoint: AppConstants.ordersPaymentInit,
            parameters: buildPaymentInitBody(orderId: orderId),
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight(
          (right) => OrderPaymentCreateResponse.fromJson(convertToMap(right)),
        );
  }

  @override
  Future<Either<ResponseError, OrderPaymentSubmitResponse>> submitPayment({
    required Map<String, dynamic> body,
  }) async {
    return await _networkServices
        .safe(
          _networkServices.postRequest(
            endPoint: AppConstants.ordersPayment,
            parameters: body,
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight(
          (right) => OrderPaymentSubmitResponse.fromJson(convertToMap(right)),
        );
  }
}

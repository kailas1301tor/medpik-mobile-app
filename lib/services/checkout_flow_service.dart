// lib/services/checkout_flow_service.dart
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/services/cart_facade_service.dart';
import 'package:tsuite/services/repo_di.dart';
import 'package:tsuite/src/checkout/repo/checkout_repository.dart';

part 'checkout_flow_service.g.dart';

class CheckoutOrderResult {
  const CheckoutOrderResult._({this.orderId, this.error});

  const CheckoutOrderResult.success(String orderId)
      : this._(orderId: orderId, error: null);

  const CheckoutOrderResult.failure(ResponseError error)
      : this._(orderId: null, error: error);

  final String? orderId;
  final ResponseError? error;

  bool get isSuccess => orderId != null;
}

@Riverpod(keepAlive: true)
CheckoutFlowService checkoutFlowService(Ref ref) {
  return CheckoutFlowService(ref);
}

class CheckoutFlowService {
  CheckoutFlowService(this._ref);

  final Ref _ref;
  late final CheckoutRepo _checkoutRepo = _ref.read(checkoutRepositoryProvider);

  Future<CheckoutOrderResult> placeOrder({
    required int addressId,
    required String deliveryInstructions,
  }) async {
    return await _checkoutRepo
        .placeOrder(
          addressId: addressId,
          deliveryInstructions: deliveryInstructions,
        )
        .fold(
          (error) => CheckoutOrderResult.failure(error),
          (response) {
            final orderId = response.orderId.trim();
            if (orderId.isEmpty) {
              return CheckoutOrderResult.failure(
                ResponseError(
                  message: Strings.somethingWentWrong,
                  key: ApiErrorTypes.oops,
                ),
              );
            }
            return CheckoutOrderResult.success(orderId);
          },
        )
        .catchError((_) {
          return CheckoutOrderResult.failure(
            ResponseError(
              message: Strings.somethingWentWrong,
              key: ApiErrorTypes.oops,
            ),
          );
        });
  }

  Future<void> refreshCartAfterOrder() {
    return _ref.read(cartFacadeServiceProvider).fetchCart(showLoader: false);
  }
}

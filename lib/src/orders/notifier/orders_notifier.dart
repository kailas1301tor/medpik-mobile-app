// lib/src/orders/notifier/orders_notifier.dart
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/data/models/order_model.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/services/razorpay_payment_service.dart';
import 'package:medpik/services/repo_di.dart';
import 'package:medpik/src/orders/model/order_payment_outcome.dart';
import 'package:medpik/src/orders/repo/orders_repository.dart';
import 'package:medpik/src/orders/state/orders_state.dart';
import 'package:medpik/utils/helpers/api_error_handler.dart';
import 'package:medpik/utils/helpers/order_payment_request_helper.dart';
import 'package:medpik/utils/helpers/razorpay_checkout_options_helper.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';
import 'package:medpik/utils/helpers/toast_helper.dart';

part 'orders_notifier.g.dart';

@Riverpod(keepAlive: false)
class OrdersNotifier extends _$OrdersNotifier {
  late OrdersRepo ordersRepo;
  late final TextEditingController rejectReasonController;

  @override
  OrdersState build() {
    ordersRepo = ref.read(ordersRepositoryProvider);
    rejectReasonController = TextEditingController();

    ref.onDispose(rejectReasonController.dispose);

    Future.microtask(fetchOrders);
    return const OrdersState(loaderState: LoaderState.loading);
  }

  Future<void> fetchOrders() async {
    state = state.copyWith(loaderState: LoaderState.loading);

    return await ordersRepo
        .getOrders()
        .fold(
          (error) {
            final loaderState = handleResponseError(error.key);
            debugPrint("🔴 ORDERS ERROR: ${error.message}");
            state = state.copyWith(loaderState: loaderState);
          },
          (response) {
            final orders = List<OrderModel>.from(response.orders)
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
            state = state.copyWith(
              loaderState:
                  orders.isEmpty ? LoaderState.noData : LoaderState.loaded,
              orders: orders,
            );
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED ORDERS ERROR: $error");
          state = state.copyWith(loaderState: LoaderState.error);
        });
  }

  Future<void> loadOrderDetail(String orderId) async {
    final trimmedId = orderId.trim();
    if (trimmedId.isEmpty) {
      state = state.copyWith(detailLoaderState: LoaderState.error);
      return;
    }

    state = state.copyWith(detailLoaderState: LoaderState.loading);
    if (state.selectedOrder?.id != trimmedId) {
      state = state.copyWith(selectedOrder: null);
    }

    return await ordersRepo
        .getOrderById(trimmedId)
        .fold(
          (error) {
            final loaderState = handleResponseError(error.key);
            debugPrint("🔴 ORDER DETAIL ERROR: ${error.message}");
            state = state.copyWith(detailLoaderState: loaderState);
          },
          (response) {
            final order = response.order;
            if (order == null || order.id.isEmpty) {
              state = state.copyWith(detailLoaderState: LoaderState.noData);
              return;
            }
            state = state.copyWith(
              detailLoaderState: LoaderState.loaded,
              selectedOrder: order,
            );
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED ORDER DETAIL ERROR: $error");
          state = state.copyWith(detailLoaderState: LoaderState.error);
        });
  }

  void selectPaymentMethod(OrderPaymentMethod method) {
    state = state.copyWith(selectedPaymentMethod: method);
  }

  void clearRejectReason() {
    rejectReasonController.clear();
  }

  Future<bool> acceptBill(String orderId) async {
    debugPrint("🔵 ACTION: acceptBill called");
    final parsedOrderId = convertToInt(orderId);
    if (parsedOrderId <= 0) {
      showCustomErrorToast(message: Strings.billActionFailed);
      return false;
    }

    state = state.copyWith(isAcceptBillLoading: true);

    var succeeded = false;
    await ordersRepo
        .submitBillAction(orderId: parsedOrderId, action: 'accept')
        .fold(
          (error) {
            debugPrint("🔴 BILL ACCEPT ERROR: ${error.message}");
            showCustomErrorToast(
              message: (error.message ?? '').isNotEmpty
                  ? error.message!
                  : Strings.billActionFailed,
            );
          },
          (response) async {
            debugPrint("🟢 BILL ACCEPT SUCCESS: ${response.message}");
            showCustomToast(
              message: response.message.isNotEmpty
                  ? response.message
                  : Strings.billAcceptedToast,
            );
            await fetchOrders();
            await loadOrderDetail(orderId);
            succeeded = true;
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED BILL ACCEPT ERROR: $error");
          showCustomErrorToast(message: Strings.billActionFailed);
        });
    state = state.copyWith(isAcceptBillLoading: false);
    return succeeded;
  }

  Future<bool> rejectBill({
    required String orderId,
    String? rejectReason,
  }) async {
    debugPrint("🔵 ACTION: rejectBill called");
    final parsedOrderId = convertToInt(orderId);
    if (parsedOrderId <= 0) {
      showCustomErrorToast(message: Strings.billActionFailed);
      return false;
    }

    state = state.copyWith(isRejectBillLoading: true);

    var succeeded = false;
    await ordersRepo
        .submitBillAction(
          orderId: parsedOrderId,
          action: 'reject',
          rejectReason: rejectReason,
        )
        .fold(
          (error) {
            debugPrint("🔴 BILL REJECT ERROR: ${error.message}");
            showCustomErrorToast(
              message: (error.message ?? '').isNotEmpty
                  ? error.message!
                  : Strings.billActionFailed,
            );
          },
          (response) async {
            debugPrint("🟢 BILL REJECT SUCCESS: ${response.message}");
            showCustomToast(
              message: response.message.isNotEmpty
                  ? response.message
                  : Strings.billRejectedToast,
            );
            clearRejectReason();
            await fetchOrders();
            await loadOrderDetail(orderId);
            succeeded = true;
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED BILL REJECT ERROR: $error");
          showCustomErrorToast(message: Strings.billActionFailed);
        });
    state = state.copyWith(isRejectBillLoading: false);
    return succeeded;
  }

  Future<OrderPaymentResult> payOrder({required String orderId}) async {
    debugPrint('🔵 ACTION: payOrder called orderId=$orderId');

    final parsedOrderId = convertToInt(orderId);
    if (parsedOrderId <= 0) {
      return const OrderPaymentResult(outcome: OrderPaymentOutcome.failure);
    }

    state = state.copyWith(isPaymentLoading: true);

    final result = state.selectedPaymentMethod == OrderPaymentMethod.cashOnDelivery
        ? await _submitCodPayment(
            orderId: orderId,
            parsedOrderId: parsedOrderId,
          )
        : await _payOnline(orderId: orderId, parsedOrderId: parsedOrderId);

    state = state.copyWith(isPaymentLoading: false);
    return result;
  }

  Future<void> _refreshOrderData(String orderId) async {
    await fetchOrders();
    await loadOrderDetail(orderId);
  }

  Future<OrderPaymentResult> _submitCodPayment({
    required String orderId,
    required int parsedOrderId,
  }) async {
    return await ordersRepo
        .submitPayment(body: buildCodPaymentBody(orderId: parsedOrderId))
        .fold(
          (error) async {
            debugPrint('🔴 COD PAYMENT ERROR: ${error.message}');
            await _refreshOrderData(orderId);
            return OrderPaymentResult(
              outcome: OrderPaymentOutcome.failure,
              message: (error.message ?? '').isNotEmpty
                  ? error.message!
                  : Strings.paymentFailed,
            );
          },
          (response) async {
            debugPrint('🟢 COD PAYMENT SUCCESS: ${response.message}');
            await _refreshOrderData(orderId);
            return const OrderPaymentResult(outcome: OrderPaymentOutcome.success);
          },
        )
        .catchError((error) {
          debugPrint('🔴 UNEXPECTED COD PAYMENT ERROR: $error');
          return const OrderPaymentResult(outcome: OrderPaymentOutcome.failure);
        });
  }

  Future<OrderPaymentResult> _payOnline({
    required String orderId,
    required int parsedOrderId,
  }) async {
    final initResult = await ordersRepo.initPayment(orderId: parsedOrderId).fold(
      (error) async {
        debugPrint('🔴 INIT PAYMENT ERROR: ${error.message}');
        return null;
      },
      (response) async => response,
    ).catchError((error) {
      debugPrint('🔴 UNEXPECTED INIT PAYMENT ERROR: $error');
      return null;
    });

    if (initResult == null) {
      return const OrderPaymentResult(
        outcome: OrderPaymentOutcome.failure,
        message: Strings.paymentFailed,
      );
    }

    final checkoutData = initResult.checkoutData;
    if (checkoutData == null ||
        checkoutData.razorpayKey.trim().isEmpty ||
        checkoutData.razorpayOrderId.trim().isEmpty ||
        checkoutData.amount <= 0) {
      debugPrint('🔴 INIT PAYMENT ERROR: invalid checkout data');
      return const OrderPaymentResult(
        outcome: OrderPaymentOutcome.failure,
        message: Strings.paymentFailed,
      );
    }

    final razorpayService = ref.read(razorpayPaymentServiceProvider);
    state = state.copyWith(isPaymentLoading: false);
    final checkoutResult = await razorpayService.openCheckout(
      buildRazorpayCheckoutOptions(checkoutData),
    );

    if (checkoutResult.isCancelled) {
      debugPrint('🟡 PAYMENT CANCELLED');
      await _reportRazorpayFailure(
        parsedOrderId: parsedOrderId,
        razorpayOrderId: checkoutData.razorpayOrderId,
        paymentResponseData: {
          'description': checkoutResult.message.isNotEmpty
              ? checkoutResult.message
              : Strings.paymentCancelled,
        },
      );
      await _refreshOrderData(orderId);
      return OrderPaymentResult(
        outcome: OrderPaymentOutcome.cancelled,
        message: checkoutResult.message.isNotEmpty
            ? checkoutResult.message
            : Strings.paymentCancelled,
      );
    }

    if (!checkoutResult.isSuccess) {
      debugPrint('🔴 PAYMENT CHECKOUT ERROR: ${checkoutResult.message}');
      await _reportRazorpayFailure(
        parsedOrderId: parsedOrderId,
        razorpayOrderId: checkoutData.razorpayOrderId,
        paymentResponseData: {
          'description': checkoutResult.message.isNotEmpty
              ? checkoutResult.message
              : Strings.paymentFailed,
        },
      );
      await _refreshOrderData(orderId);
      return OrderPaymentResult(
        outcome: OrderPaymentOutcome.failure,
        message: checkoutResult.message.trim().isNotEmpty
            ? checkoutResult.message
            : Strings.paymentFailed,
      );
    }

    return await _submitRazorpaySuccess(
      orderId: orderId,
      parsedOrderId: parsedOrderId,
      razorpayOrderId: checkoutResult.orderId.isNotEmpty
          ? checkoutResult.orderId
          : checkoutData.razorpayOrderId,
      razorpayPaymentId: checkoutResult.paymentId,
      razorpaySignature: checkoutResult.signature,
    );
  }

  Future<void> _reportRazorpayFailure({
    required int parsedOrderId,
    required String razorpayOrderId,
    Map<String, dynamic> paymentResponseData = const {},
  }) async {
    await ordersRepo
        .submitPayment(
          body: buildRazorpayFailedPaymentBody(
            orderId: parsedOrderId,
            razorpayOrderId: razorpayOrderId,
            paymentResponseData: paymentResponseData,
          ),
        )
        .fold(
          (error) {
            debugPrint('🔴 REPORT PAYMENT FAILURE ERROR: ${error.message}');
          },
          (response) {
            debugPrint('🟢 REPORT PAYMENT FAILURE: ${response.message}');
          },
        )
        .catchError((error) {
          debugPrint('🔴 UNEXPECTED REPORT PAYMENT FAILURE ERROR: $error');
        });
  }

  Future<OrderPaymentResult> _submitRazorpaySuccess({
    required String orderId,
    required int parsedOrderId,
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    return await ordersRepo
        .submitPayment(
          body: buildRazorpaySuccessPaymentBody(
            orderId: parsedOrderId,
            razorpayOrderId: razorpayOrderId,
            razorpayPaymentId: razorpayPaymentId,
            razorpaySignature: razorpaySignature,
          ),
        )
        .fold(
          (error) async {
            debugPrint('🔴 SUBMIT PAYMENT ERROR: ${error.message}');
            await _refreshOrderData(orderId);
            return OrderPaymentResult(
              outcome: OrderPaymentOutcome.failure,
              message: (error.message ?? '').isNotEmpty
                  ? error.message!
                  : Strings.paymentFailed,
            );
          },
          (response) async {
            debugPrint('🟢 SUBMIT PAYMENT SUCCESS: ${response.message}');
            await _refreshOrderData(orderId);
            return const OrderPaymentResult(outcome: OrderPaymentOutcome.success);
          },
        )
        .catchError((error) {
          debugPrint('🔴 UNEXPECTED SUBMIT PAYMENT ERROR: $error');
          return const OrderPaymentResult(outcome: OrderPaymentOutcome.failure);
        });
  }
}

@Riverpod(keepAlive: false)
void orderDetailLoader(Ref ref, String orderId) {
  Future.microtask(
    () => ref.read(ordersNotifierProvider.notifier).loadOrderDetail(orderId),
  );
}

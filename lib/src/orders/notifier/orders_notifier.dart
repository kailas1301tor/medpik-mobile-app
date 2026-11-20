// lib/src/orders/notifier/orders_notifier.dart
import 'dart:async';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/data/models/order_model.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/services/analytics_service.dart';
import 'package:medpik/services/razorpay_payment_service.dart';
import 'package:medpik/services/repo_di.dart';
import 'package:medpik/data/remote/network_base_services.dart';
import 'package:medpik/src/orders/helper/pending_payment_store.dart';
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

  static const int _verifyMaxAttempts = 3;

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
            debugPrint("🔴 ORDERS ERROR: ${error.message}");
            state = state.copyWith(
              loaderState: loaderStateForSessionAwareError(error.key),
            );
          },
          (response) {
            final orders = List<OrderModel>.from(response.orders)
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
            state = state.copyWith(
              loaderState: orders.isEmpty
                  ? LoaderState.noData
                  : LoaderState.loaded,
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
            debugPrint("🔴 ORDER DETAIL ERROR: ${error.message}");
            state = state.copyWith(
              detailLoaderState: loaderStateForSessionAwareError(error.key),
            );
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
              message: resolveApiErrorMessage(
                error: error,
                fallback: Strings.billActionFailed,
              ),
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
              message: resolveApiErrorMessage(
                error: error,
                fallback: Strings.billActionFailed,
              ),
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

    if (state.isPaymentLoading) {
      return const OrderPaymentResult(
        outcome: OrderPaymentOutcome.failure,
        message: Strings.paymentAlreadyInProgress,
      );
    }

    final parsedOrderId = convertToInt(orderId);
    if (parsedOrderId <= 0) {
      return const OrderPaymentResult(
        outcome: OrderPaymentOutcome.failure,
        message: Strings.paymentFailed,
      );
    }

    state = state.copyWith(isPaymentLoading: true);

    try {
      if (state.selectedPaymentMethod == OrderPaymentMethod.cashOnDelivery) {
        return await _submitCodPayment(
          orderId: orderId,
          parsedOrderId: parsedOrderId,
        );
      }
      return await _payOnline(
        orderId: orderId,
        parsedOrderId: parsedOrderId,
      );
    } catch (error, stack) {
      debugPrint('🔴 UNEXPECTED PAY ORDER ERROR: $error');
      debugPrint('$stack');
      return const OrderPaymentResult(
        outcome: OrderPaymentOutcome.failure,
        message: Strings.paymentFailed,
      );
    } finally {
      state = state.copyWith(isPaymentLoading: false);
    }
  }

  /// Call on app launch to finish a payment interrupted by kill/background.
  Future<OrderPaymentResult?> resumePendingPaymentIfAny() async {
    final pending = await PendingPaymentStore.read();
    if (pending == null) return null;

    if (!pending.canResumeVerify) {
      showCustomErrorToast(message: Strings.paymentPendingIncompletePrompt);
      return const OrderPaymentResult(
        outcome: OrderPaymentOutcome.failure,
        message: Strings.paymentPendingIncompletePrompt,
      );
    }

    if (state.isPaymentLoading) {
      return const OrderPaymentResult(
        outcome: OrderPaymentOutcome.failure,
        message: Strings.paymentAlreadyInProgress,
      );
    }

    showCustomToast(message: Strings.paymentPendingResumePrompt);
    state = state.copyWith(isPaymentLoading: true);
    try {
      return await _submitRazorpaySuccess(
        orderId: pending.orderId,
        parsedOrderId: pending.parsedOrderId,
        razorpayOrderId: pending.razorpayOrderId,
        razorpayPaymentId: pending.razorpayPaymentId,
        razorpaySignature: pending.razorpaySignature,
      );
    } finally {
      state = state.copyWith(isPaymentLoading: false);
    }
  }

  Future<void> _refreshOrderData(String orderId) async {
    await fetchOrders();
    await loadOrderDetail(orderId);
  }

  bool _isRetryableNetworkError(ApiErrorTypes key) {
    return key == ApiErrorTypes.noInternet ||
        key == ApiErrorTypes.connectionError ||
        key == ApiErrorTypes.connectionTimeout ||
        key == ApiErrorTypes.sendTimeout ||
        key == ApiErrorTypes.receiveTimeout;
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
              message: resolveApiErrorMessage(
                error: error,
                fallback: Strings.paymentFailed,
              ),
            );
          },
          (response) async {
            debugPrint('🟢 COD PAYMENT SUCCESS: ${response.message}');
            await PendingPaymentStore.clear();
            await _refreshOrderData(orderId);
            return const OrderPaymentResult(
              outcome: OrderPaymentOutcome.success,
              isCashOnDelivery: true,
            );
          },
        )
        .catchError((error) async {
          debugPrint('🔴 UNEXPECTED COD PAYMENT ERROR: $error');
          await _refreshOrderData(orderId);
          return const OrderPaymentResult(
            outcome: OrderPaymentOutcome.failure,
            message: Strings.paymentFailed,
          );
        });
  }

  Future<OrderPaymentResult> _payOnline({
    required String orderId,
    required int parsedOrderId,
  }) async {
    final initResult = await ordersRepo
        .initPayment(orderId: parsedOrderId)
        .fold((error) async {
          debugPrint('🔴 INIT PAYMENT ERROR: ${error.message}');
          return null;
        }, (response) async => response)
        .catchError((error) {
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
    final razorpayKey = checkoutData?.razorpayKey.trim() ?? '';
    final razorpayOrderId = checkoutData?.razorpayOrderId.trim() ?? '';
    final amount = checkoutData?.amount ?? 0;
    if (checkoutData == null ||
        razorpayKey.isEmpty ||
        razorpayOrderId.isEmpty ||
        amount <= 0) {
      debugPrint('🔴 INIT PAYMENT ERROR: invalid checkout data');
      return const OrderPaymentResult(
        outcome: OrderPaymentOutcome.failure,
        message: Strings.paymentFailed,
      );
    }

    await PendingPaymentStore.save(
      PendingPaymentSnapshot(
        orderId: orderId,
        parsedOrderId: parsedOrderId,
        razorpayOrderId: razorpayOrderId,
      ),
    );

    final razorpayService = ref.read(razorpayPaymentServiceProvider);
    final RazorpayCheckoutResult checkoutResult;
    try {
      checkoutResult = await razorpayService.openCheckout(
        buildRazorpayCheckoutOptions(checkoutData),
      );
    } catch (error, stack) {
      debugPrint('🔴 UNEXPECTED RAZORPAY SDK ERROR: $error');
      debugPrint('$stack');
      await _reportRazorpayFailure(
        parsedOrderId: parsedOrderId,
        razorpayOrderId: razorpayOrderId,
        paymentResponseData: {
          'description': error.toString().trim().isNotEmpty
              ? error.toString()
              : Strings.paymentFailed,
        },
      );
      await PendingPaymentStore.clear();
      await _refreshOrderData(orderId);
      return const OrderPaymentResult(
        outcome: OrderPaymentOutcome.failure,
        message: Strings.paymentFailed,
      );
    }

    if (checkoutResult.isCancelled) {
      debugPrint('🟡 PAYMENT CANCELLED');
      await _reportRazorpayFailure(
        parsedOrderId: parsedOrderId,
        razorpayOrderId: razorpayOrderId,
        paymentResponseData: {
          'description': checkoutResult.message.trim().isNotEmpty
              ? checkoutResult.message
              : Strings.paymentCancelled,
        },
      );
      await PendingPaymentStore.clear();
      await _refreshOrderData(orderId);
      return OrderPaymentResult(
        outcome: OrderPaymentOutcome.cancelled,
        message: checkoutResult.message.trim().isNotEmpty
            ? checkoutResult.message
            : Strings.paymentCancelled,
      );
    }

    if (!checkoutResult.isSuccess) {
      debugPrint('🔴 PAYMENT CHECKOUT ERROR: ${checkoutResult.message}');
      await _reportRazorpayFailure(
        parsedOrderId: parsedOrderId,
        razorpayOrderId: razorpayOrderId,
        paymentResponseData: {
          'description': checkoutResult.message.trim().isNotEmpty
              ? checkoutResult.message
              : Strings.paymentFailed,
        },
      );
      await PendingPaymentStore.clear();
      await _refreshOrderData(orderId);
      return OrderPaymentResult(
        outcome: OrderPaymentOutcome.failure,
        message: checkoutResult.message.trim().isNotEmpty
            ? checkoutResult.message
            : Strings.paymentFailed,
      );
    }

    final paymentId = checkoutResult.paymentId.trim();
    final signature = checkoutResult.signature.trim();
    final successOrderId = checkoutResult.orderId.trim().isNotEmpty
        ? checkoutResult.orderId.trim()
        : razorpayOrderId;

    if (paymentId.isEmpty || signature.isEmpty) {
      await _reportRazorpayFailure(
        parsedOrderId: parsedOrderId,
        razorpayOrderId: successOrderId,
        paymentResponseData: const {'description': 'Missing payment fields'},
      );
      await PendingPaymentStore.clear();
      await _refreshOrderData(orderId);
      return const OrderPaymentResult(
        outcome: OrderPaymentOutcome.failure,
        message: Strings.paymentFailed,
      );
    }

    return await _submitRazorpaySuccess(
      orderId: orderId,
      parsedOrderId: parsedOrderId,
      razorpayOrderId: successOrderId,
      razorpayPaymentId: paymentId,
      razorpaySignature: signature,
    );
  }

  Future<void> _reportRazorpayFailure({
    required int parsedOrderId,
    required String razorpayOrderId,
    String razorpayPaymentId = '',
    String razorpaySignature = '',
    Map<String, dynamic> paymentResponseData = const {},
  }) async {
    await ordersRepo
        .submitPayment(
          body: buildRazorpayFailedPaymentBody(
            orderId: parsedOrderId,
            razorpayOrderId: razorpayOrderId,
            razorpayPaymentId: razorpayPaymentId,
            razorpaySignature: razorpaySignature,
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
    await PendingPaymentStore.save(
      PendingPaymentSnapshot(
        orderId: orderId,
        parsedOrderId: parsedOrderId,
        razorpayOrderId: razorpayOrderId,
        razorpayPaymentId: razorpayPaymentId,
        razorpaySignature: razorpaySignature,
      ),
    );

    ResponseError? lastError;

    for (var attempt = 1; attempt <= _verifyMaxAttempts; attempt++) {
      try {
        final either = await ordersRepo.submitPayment(
          body: buildRazorpaySuccessPaymentBody(
            orderId: parsedOrderId,
            razorpayOrderId: razorpayOrderId,
            razorpayPaymentId: razorpayPaymentId,
            razorpaySignature: razorpaySignature,
          ),
        );

        final success = await either.fold(
          (error) async {
            lastError = error;
            debugPrint(
              '🔴 SUBMIT PAYMENT ERROR (attempt $attempt): ${error.message}',
            );
            return false;
          },
          (response) async {
            debugPrint('🟢 SUBMIT PAYMENT SUCCESS: ${response.message}');
            return true;
          },
        );

        if (success) {
          await PendingPaymentStore.clear();
          await _refreshOrderData(orderId);
          if (razorpaySignature.trim().isNotEmpty) {
            unawaited(
              AnalyticsService.instance.logPaymentResult(outcome: 'success'),
            );
          }
          return const OrderPaymentResult(
            outcome: OrderPaymentOutcome.success,
          );
        }

        final error = lastError;
        final canRetry =
            error != null &&
            _isRetryableNetworkError(error.key) &&
            attempt < _verifyMaxAttempts;
        if (!canRetry) break;

        final delayMs = 500 * (1 << (attempt - 1));
        await Future<void>.delayed(Duration(milliseconds: delayMs));
      } catch (error, stack) {
        debugPrint('🔴 UNEXPECTED SUBMIT PAYMENT ERROR: $error');
        debugPrint('$stack');
        lastError = null;
        if (attempt >= _verifyMaxAttempts) break;
        final delayMs = 500 * (1 << (attempt - 1));
        await Future<void>.delayed(Duration(milliseconds: delayMs));
      }
    }

    final failedError = lastError;
    await _reportRazorpayFailure(
      parsedOrderId: parsedOrderId,
      razorpayOrderId: razorpayOrderId,
      razorpayPaymentId: razorpayPaymentId,
      razorpaySignature: razorpaySignature,
      paymentResponseData: {
        'description': failedError == null
            ? Strings.paymentMayHaveGoneThrough
            : resolveApiErrorMessage(
                error: failedError,
                fallback: Strings.paymentMayHaveGoneThrough,
              ),
      },
    );
    // Keep pending so the next launch can retry verify (backend should be
    // idempotent). User is warned that payment may already have gone through.
    await _refreshOrderData(orderId);
    return const OrderPaymentResult(
      outcome: OrderPaymentOutcome.failure,
      message: Strings.paymentMayHaveGoneThrough,
    );
  }
}

@Riverpod(keepAlive: false)
void orderDetailLoader(Ref ref, String orderId) {
  Future.microtask(
    () => ref.read(ordersNotifierProvider.notifier).loadOrderDetail(orderId),
  );
}

// lib/src/orders/notifier/orders_notifier.dart
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/data/models/order_model.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/services/repo_di.dart';
import 'package:tsuite/src/orders/repo/orders_repository.dart';
import 'package:tsuite/src/orders/state/orders_state.dart';
import 'package:tsuite/utils/helpers/api_error_handler.dart';
import 'package:tsuite/utils/helpers/toast_helper.dart';

part 'orders_notifier.g.dart';

@Riverpod(keepAlive: false)
class OrdersNotifier extends _$OrdersNotifier {
  late OrdersRepo ordersRepo;

  @override
  OrdersState build() {
    ordersRepo = ref.read(ordersRepositoryProvider);
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
          (orders) {
            final sorted = List<OrderModel>.from(orders)
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
            state = state.copyWith(
              loaderState:
                  orders.isEmpty ? LoaderState.noData : LoaderState.loaded,
              orders: sorted,
            );
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED ORDERS ERROR: $error");
          state = state.copyWith(loaderState: LoaderState.error);
        });
  }

  Future<void> loadOrderDetail(String orderId) async {
    state = state.copyWith(detailLoaderState: LoaderState.loading);

    return await ordersRepo
        .getOrderById(orderId)
        .fold(
          (error) {
            final loaderState = handleResponseError(error.key);
            debugPrint("🔴 ORDER DETAIL ERROR: ${error.message}");
            state = state.copyWith(detailLoaderState: loaderState);
          },
          (order) {
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

  void acceptBill() {
    debugPrint("🔵 ACTION: acceptBill called");
    showCustomToast(message: Strings.billAcceptedToast);
  }

  void rejectBill() {
    debugPrint("🔵 ACTION: rejectBill called");
    showCustomToast(message: Strings.billRejectedToast);
  }

  void payOrder() {
    debugPrint("🔵 ACTION: payOrder called");
    showCustomToast(message: Strings.paymentSuccessToast);
  }
}

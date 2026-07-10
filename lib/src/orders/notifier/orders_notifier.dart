// lib/src/orders/notifier/orders_notifier.dart
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/services/repo_di.dart';
import 'package:tsuite/src/orders/repo/orders_repository.dart';
import 'package:tsuite/src/orders/state/orders_state.dart';
import 'package:tsuite/utils/helpers/api_error_handler.dart';

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
            final active = orders.where((o) => o.isActive).toList();
            final past = orders.where((o) => !o.isActive).toList();
            state = state.copyWith(
              loaderState:
                  orders.isEmpty ? LoaderState.noData : LoaderState.loaded,
              activeOrders: active,
              pastOrders: past,
            );
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED ORDERS ERROR: $error");
          state = state.copyWith(loaderState: LoaderState.error);
        });
  }

  Future<void> loadOrderDetail(String orderId) async {
    state = state.copyWith(loaderState: LoaderState.loading);

    return await ordersRepo
        .getOrderById(orderId)
        .fold(
          (error) {
            final loaderState = handleResponseError(error.key);
            state = state.copyWith(loaderState: loaderState);
          },
          (order) {
            state = state.copyWith(
              loaderState: LoaderState.loaded,
              selectedOrder: order,
            );
          },
        )
        .catchError((error) {
          state = state.copyWith(loaderState: LoaderState.error);
        });
  }
}

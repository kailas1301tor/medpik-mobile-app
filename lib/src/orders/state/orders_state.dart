// lib/src/orders/state/orders_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tsuite/data/models/order_model.dart';
import 'package:tsuite/res/enums/enums.dart';

part 'orders_state.freezed.dart';

@freezed
sealed class OrdersState with _$OrdersState {
  const factory OrdersState({
    @Default(LoaderState.loaded) LoaderState loaderState,
    @Default(LoaderState.loaded) LoaderState detailLoaderState,
    @Default([]) List<OrderModel> orders,
    OrderModel? selectedOrder,
    @Default(OrderPaymentMethod.online) OrderPaymentMethod selectedPaymentMethod,
    String? errorMessage,
  }) = _OrdersState;
}

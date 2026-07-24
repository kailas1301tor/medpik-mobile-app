// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'orders_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$OrdersState {
  LoaderState get loaderState => throw _privateConstructorUsedError;
  LoaderState get detailLoaderState => throw _privateConstructorUsedError;
  List<OrderModel> get orders => throw _privateConstructorUsedError;
  OrderModel? get selectedOrder => throw _privateConstructorUsedError;
  OrderPaymentMethod get selectedPaymentMethod =>
      throw _privateConstructorUsedError;
  bool get isAcceptBillLoading => throw _privateConstructorUsedError;
  bool get isRejectBillLoading => throw _privateConstructorUsedError;
  bool get isPaymentLoading => throw _privateConstructorUsedError;

  /// Create a copy of OrdersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrdersStateCopyWith<OrdersState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrdersStateCopyWith<$Res> {
  factory $OrdersStateCopyWith(
    OrdersState value,
    $Res Function(OrdersState) then,
  ) = _$OrdersStateCopyWithImpl<$Res, OrdersState>;
  @useResult
  $Res call({
    LoaderState loaderState,
    LoaderState detailLoaderState,
    List<OrderModel> orders,
    OrderModel? selectedOrder,
    OrderPaymentMethod selectedPaymentMethod,
    bool isAcceptBillLoading,
    bool isRejectBillLoading,
    bool isPaymentLoading,
  });
}

/// @nodoc
class _$OrdersStateCopyWithImpl<$Res, $Val extends OrdersState>
    implements $OrdersStateCopyWith<$Res> {
  _$OrdersStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrdersState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loaderState = null,
    Object? detailLoaderState = null,
    Object? orders = null,
    Object? selectedOrder = freezed,
    Object? selectedPaymentMethod = null,
    Object? isAcceptBillLoading = null,
    Object? isRejectBillLoading = null,
    Object? isPaymentLoading = null,
  }) {
    return _then(
      _value.copyWith(
            loaderState: null == loaderState
                ? _value.loaderState
                : loaderState // ignore: cast_nullable_to_non_nullable
                      as LoaderState,
            detailLoaderState: null == detailLoaderState
                ? _value.detailLoaderState
                : detailLoaderState // ignore: cast_nullable_to_non_nullable
                      as LoaderState,
            orders: null == orders
                ? _value.orders
                : orders // ignore: cast_nullable_to_non_nullable
                      as List<OrderModel>,
            selectedOrder: freezed == selectedOrder
                ? _value.selectedOrder
                : selectedOrder // ignore: cast_nullable_to_non_nullable
                      as OrderModel?,
            selectedPaymentMethod: null == selectedPaymentMethod
                ? _value.selectedPaymentMethod
                : selectedPaymentMethod // ignore: cast_nullable_to_non_nullable
                      as OrderPaymentMethod,
            isAcceptBillLoading: null == isAcceptBillLoading
                ? _value.isAcceptBillLoading
                : isAcceptBillLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isRejectBillLoading: null == isRejectBillLoading
                ? _value.isRejectBillLoading
                : isRejectBillLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isPaymentLoading: null == isPaymentLoading
                ? _value.isPaymentLoading
                : isPaymentLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrdersStateImplCopyWith<$Res>
    implements $OrdersStateCopyWith<$Res> {
  factory _$$OrdersStateImplCopyWith(
    _$OrdersStateImpl value,
    $Res Function(_$OrdersStateImpl) then,
  ) = __$$OrdersStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    LoaderState loaderState,
    LoaderState detailLoaderState,
    List<OrderModel> orders,
    OrderModel? selectedOrder,
    OrderPaymentMethod selectedPaymentMethod,
    bool isAcceptBillLoading,
    bool isRejectBillLoading,
    bool isPaymentLoading,
  });
}

/// @nodoc
class __$$OrdersStateImplCopyWithImpl<$Res>
    extends _$OrdersStateCopyWithImpl<$Res, _$OrdersStateImpl>
    implements _$$OrdersStateImplCopyWith<$Res> {
  __$$OrdersStateImplCopyWithImpl(
    _$OrdersStateImpl _value,
    $Res Function(_$OrdersStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrdersState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loaderState = null,
    Object? detailLoaderState = null,
    Object? orders = null,
    Object? selectedOrder = freezed,
    Object? selectedPaymentMethod = null,
    Object? isAcceptBillLoading = null,
    Object? isRejectBillLoading = null,
    Object? isPaymentLoading = null,
  }) {
    return _then(
      _$OrdersStateImpl(
        loaderState: null == loaderState
            ? _value.loaderState
            : loaderState // ignore: cast_nullable_to_non_nullable
                  as LoaderState,
        detailLoaderState: null == detailLoaderState
            ? _value.detailLoaderState
            : detailLoaderState // ignore: cast_nullable_to_non_nullable
                  as LoaderState,
        orders: null == orders
            ? _value._orders
            : orders // ignore: cast_nullable_to_non_nullable
                  as List<OrderModel>,
        selectedOrder: freezed == selectedOrder
            ? _value.selectedOrder
            : selectedOrder // ignore: cast_nullable_to_non_nullable
                  as OrderModel?,
        selectedPaymentMethod: null == selectedPaymentMethod
            ? _value.selectedPaymentMethod
            : selectedPaymentMethod // ignore: cast_nullable_to_non_nullable
                  as OrderPaymentMethod,
        isAcceptBillLoading: null == isAcceptBillLoading
            ? _value.isAcceptBillLoading
            : isAcceptBillLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isRejectBillLoading: null == isRejectBillLoading
            ? _value.isRejectBillLoading
            : isRejectBillLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isPaymentLoading: null == isPaymentLoading
            ? _value.isPaymentLoading
            : isPaymentLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$OrdersStateImpl implements _OrdersState {
  const _$OrdersStateImpl({
    this.loaderState = LoaderState.loaded,
    this.detailLoaderState = LoaderState.loaded,
    final List<OrderModel> orders = const [],
    this.selectedOrder,
    this.selectedPaymentMethod = OrderPaymentMethod.online,
    this.isAcceptBillLoading = false,
    this.isRejectBillLoading = false,
    this.isPaymentLoading = false,
  }) : _orders = orders;

  @override
  @JsonKey()
  final LoaderState loaderState;
  @override
  @JsonKey()
  final LoaderState detailLoaderState;
  final List<OrderModel> _orders;
  @override
  @JsonKey()
  List<OrderModel> get orders {
    if (_orders is EqualUnmodifiableListView) return _orders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orders);
  }

  @override
  final OrderModel? selectedOrder;
  @override
  @JsonKey()
  final OrderPaymentMethod selectedPaymentMethod;
  @override
  @JsonKey()
  final bool isAcceptBillLoading;
  @override
  @JsonKey()
  final bool isRejectBillLoading;
  @override
  @JsonKey()
  final bool isPaymentLoading;

  @override
  String toString() {
    return 'OrdersState(loaderState: $loaderState, detailLoaderState: $detailLoaderState, orders: $orders, selectedOrder: $selectedOrder, selectedPaymentMethod: $selectedPaymentMethod, isAcceptBillLoading: $isAcceptBillLoading, isRejectBillLoading: $isRejectBillLoading, isPaymentLoading: $isPaymentLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrdersStateImpl &&
            (identical(other.loaderState, loaderState) ||
                other.loaderState == loaderState) &&
            (identical(other.detailLoaderState, detailLoaderState) ||
                other.detailLoaderState == detailLoaderState) &&
            const DeepCollectionEquality().equals(other._orders, _orders) &&
            (identical(other.selectedOrder, selectedOrder) ||
                other.selectedOrder == selectedOrder) &&
            (identical(other.selectedPaymentMethod, selectedPaymentMethod) ||
                other.selectedPaymentMethod == selectedPaymentMethod) &&
            (identical(other.isAcceptBillLoading, isAcceptBillLoading) ||
                other.isAcceptBillLoading == isAcceptBillLoading) &&
            (identical(other.isRejectBillLoading, isRejectBillLoading) ||
                other.isRejectBillLoading == isRejectBillLoading) &&
            (identical(other.isPaymentLoading, isPaymentLoading) ||
                other.isPaymentLoading == isPaymentLoading));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    loaderState,
    detailLoaderState,
    const DeepCollectionEquality().hash(_orders),
    selectedOrder,
    selectedPaymentMethod,
    isAcceptBillLoading,
    isRejectBillLoading,
    isPaymentLoading,
  );

  /// Create a copy of OrdersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrdersStateImplCopyWith<_$OrdersStateImpl> get copyWith =>
      __$$OrdersStateImplCopyWithImpl<_$OrdersStateImpl>(this, _$identity);
}

abstract class _OrdersState implements OrdersState {
  const factory _OrdersState({
    final LoaderState loaderState,
    final LoaderState detailLoaderState,
    final List<OrderModel> orders,
    final OrderModel? selectedOrder,
    final OrderPaymentMethod selectedPaymentMethod,
    final bool isAcceptBillLoading,
    final bool isRejectBillLoading,
    final bool isPaymentLoading,
  }) = _$OrdersStateImpl;

  @override
  LoaderState get loaderState;
  @override
  LoaderState get detailLoaderState;
  @override
  List<OrderModel> get orders;
  @override
  OrderModel? get selectedOrder;
  @override
  OrderPaymentMethod get selectedPaymentMethod;
  @override
  bool get isAcceptBillLoading;
  @override
  bool get isRejectBillLoading;
  @override
  bool get isPaymentLoading;

  /// Create a copy of OrdersState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrdersStateImplCopyWith<_$OrdersStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

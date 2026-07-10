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
  List<OrderModel> get activeOrders => throw _privateConstructorUsedError;
  List<OrderModel> get pastOrders => throw _privateConstructorUsedError;
  OrderModel? get selectedOrder => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

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
    List<OrderModel> activeOrders,
    List<OrderModel> pastOrders,
    OrderModel? selectedOrder,
    String? errorMessage,
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
    Object? activeOrders = null,
    Object? pastOrders = null,
    Object? selectedOrder = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            loaderState: null == loaderState
                ? _value.loaderState
                : loaderState // ignore: cast_nullable_to_non_nullable
                      as LoaderState,
            activeOrders: null == activeOrders
                ? _value.activeOrders
                : activeOrders // ignore: cast_nullable_to_non_nullable
                      as List<OrderModel>,
            pastOrders: null == pastOrders
                ? _value.pastOrders
                : pastOrders // ignore: cast_nullable_to_non_nullable
                      as List<OrderModel>,
            selectedOrder: freezed == selectedOrder
                ? _value.selectedOrder
                : selectedOrder // ignore: cast_nullable_to_non_nullable
                      as OrderModel?,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
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
    List<OrderModel> activeOrders,
    List<OrderModel> pastOrders,
    OrderModel? selectedOrder,
    String? errorMessage,
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
    Object? activeOrders = null,
    Object? pastOrders = null,
    Object? selectedOrder = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$OrdersStateImpl(
        loaderState: null == loaderState
            ? _value.loaderState
            : loaderState // ignore: cast_nullable_to_non_nullable
                  as LoaderState,
        activeOrders: null == activeOrders
            ? _value._activeOrders
            : activeOrders // ignore: cast_nullable_to_non_nullable
                  as List<OrderModel>,
        pastOrders: null == pastOrders
            ? _value._pastOrders
            : pastOrders // ignore: cast_nullable_to_non_nullable
                  as List<OrderModel>,
        selectedOrder: freezed == selectedOrder
            ? _value.selectedOrder
            : selectedOrder // ignore: cast_nullable_to_non_nullable
                  as OrderModel?,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$OrdersStateImpl implements _OrdersState {
  const _$OrdersStateImpl({
    this.loaderState = LoaderState.loaded,
    final List<OrderModel> activeOrders = const [],
    final List<OrderModel> pastOrders = const [],
    this.selectedOrder,
    this.errorMessage,
  }) : _activeOrders = activeOrders,
       _pastOrders = pastOrders;

  @override
  @JsonKey()
  final LoaderState loaderState;
  final List<OrderModel> _activeOrders;
  @override
  @JsonKey()
  List<OrderModel> get activeOrders {
    if (_activeOrders is EqualUnmodifiableListView) return _activeOrders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activeOrders);
  }

  final List<OrderModel> _pastOrders;
  @override
  @JsonKey()
  List<OrderModel> get pastOrders {
    if (_pastOrders is EqualUnmodifiableListView) return _pastOrders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pastOrders);
  }

  @override
  final OrderModel? selectedOrder;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'OrdersState(loaderState: $loaderState, activeOrders: $activeOrders, pastOrders: $pastOrders, selectedOrder: $selectedOrder, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrdersStateImpl &&
            (identical(other.loaderState, loaderState) ||
                other.loaderState == loaderState) &&
            const DeepCollectionEquality().equals(
              other._activeOrders,
              _activeOrders,
            ) &&
            const DeepCollectionEquality().equals(
              other._pastOrders,
              _pastOrders,
            ) &&
            (identical(other.selectedOrder, selectedOrder) ||
                other.selectedOrder == selectedOrder) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    loaderState,
    const DeepCollectionEquality().hash(_activeOrders),
    const DeepCollectionEquality().hash(_pastOrders),
    selectedOrder,
    errorMessage,
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
    final List<OrderModel> activeOrders,
    final List<OrderModel> pastOrders,
    final OrderModel? selectedOrder,
    final String? errorMessage,
  }) = _$OrdersStateImpl;

  @override
  LoaderState get loaderState;
  @override
  List<OrderModel> get activeOrders;
  @override
  List<OrderModel> get pastOrders;
  @override
  OrderModel? get selectedOrder;
  @override
  String? get errorMessage;

  /// Create a copy of OrdersState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrdersStateImplCopyWith<_$OrdersStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

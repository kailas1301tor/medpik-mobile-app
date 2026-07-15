// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prescription_checkout_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PrescriptionCheckoutState {
  LoaderState get loaderState => throw _privateConstructorUsedError;
  AddressModel? get selectedAddress => throw _privateConstructorUsedError;
  bool get isPlacingOrder => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  String? get placedOrderId => throw _privateConstructorUsedError;

  /// Create a copy of PrescriptionCheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrescriptionCheckoutStateCopyWith<PrescriptionCheckoutState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrescriptionCheckoutStateCopyWith<$Res> {
  factory $PrescriptionCheckoutStateCopyWith(
    PrescriptionCheckoutState value,
    $Res Function(PrescriptionCheckoutState) then,
  ) = _$PrescriptionCheckoutStateCopyWithImpl<$Res, PrescriptionCheckoutState>;
  @useResult
  $Res call({
    LoaderState loaderState,
    AddressModel? selectedAddress,
    bool isPlacingOrder,
    String? errorMessage,
    String? placedOrderId,
  });
}

/// @nodoc
class _$PrescriptionCheckoutStateCopyWithImpl<
  $Res,
  $Val extends PrescriptionCheckoutState
>
    implements $PrescriptionCheckoutStateCopyWith<$Res> {
  _$PrescriptionCheckoutStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrescriptionCheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loaderState = null,
    Object? selectedAddress = freezed,
    Object? isPlacingOrder = null,
    Object? errorMessage = freezed,
    Object? placedOrderId = freezed,
  }) {
    return _then(
      _value.copyWith(
            loaderState: null == loaderState
                ? _value.loaderState
                : loaderState // ignore: cast_nullable_to_non_nullable
                      as LoaderState,
            selectedAddress: freezed == selectedAddress
                ? _value.selectedAddress
                : selectedAddress // ignore: cast_nullable_to_non_nullable
                      as AddressModel?,
            isPlacingOrder: null == isPlacingOrder
                ? _value.isPlacingOrder
                : isPlacingOrder // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            placedOrderId: freezed == placedOrderId
                ? _value.placedOrderId
                : placedOrderId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PrescriptionCheckoutStateImplCopyWith<$Res>
    implements $PrescriptionCheckoutStateCopyWith<$Res> {
  factory _$$PrescriptionCheckoutStateImplCopyWith(
    _$PrescriptionCheckoutStateImpl value,
    $Res Function(_$PrescriptionCheckoutStateImpl) then,
  ) = __$$PrescriptionCheckoutStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    LoaderState loaderState,
    AddressModel? selectedAddress,
    bool isPlacingOrder,
    String? errorMessage,
    String? placedOrderId,
  });
}

/// @nodoc
class __$$PrescriptionCheckoutStateImplCopyWithImpl<$Res>
    extends
        _$PrescriptionCheckoutStateCopyWithImpl<
          $Res,
          _$PrescriptionCheckoutStateImpl
        >
    implements _$$PrescriptionCheckoutStateImplCopyWith<$Res> {
  __$$PrescriptionCheckoutStateImplCopyWithImpl(
    _$PrescriptionCheckoutStateImpl _value,
    $Res Function(_$PrescriptionCheckoutStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PrescriptionCheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loaderState = null,
    Object? selectedAddress = freezed,
    Object? isPlacingOrder = null,
    Object? errorMessage = freezed,
    Object? placedOrderId = freezed,
  }) {
    return _then(
      _$PrescriptionCheckoutStateImpl(
        loaderState: null == loaderState
            ? _value.loaderState
            : loaderState // ignore: cast_nullable_to_non_nullable
                  as LoaderState,
        selectedAddress: freezed == selectedAddress
            ? _value.selectedAddress
            : selectedAddress // ignore: cast_nullable_to_non_nullable
                  as AddressModel?,
        isPlacingOrder: null == isPlacingOrder
            ? _value.isPlacingOrder
            : isPlacingOrder // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        placedOrderId: freezed == placedOrderId
            ? _value.placedOrderId
            : placedOrderId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$PrescriptionCheckoutStateImpl implements _PrescriptionCheckoutState {
  const _$PrescriptionCheckoutStateImpl({
    this.loaderState = LoaderState.loaded,
    this.selectedAddress,
    this.isPlacingOrder = false,
    this.errorMessage,
    this.placedOrderId,
  });

  @override
  @JsonKey()
  final LoaderState loaderState;
  @override
  final AddressModel? selectedAddress;
  @override
  @JsonKey()
  final bool isPlacingOrder;
  @override
  final String? errorMessage;
  @override
  final String? placedOrderId;

  @override
  String toString() {
    return 'PrescriptionCheckoutState(loaderState: $loaderState, selectedAddress: $selectedAddress, isPlacingOrder: $isPlacingOrder, errorMessage: $errorMessage, placedOrderId: $placedOrderId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrescriptionCheckoutStateImpl &&
            (identical(other.loaderState, loaderState) ||
                other.loaderState == loaderState) &&
            (identical(other.selectedAddress, selectedAddress) ||
                other.selectedAddress == selectedAddress) &&
            (identical(other.isPlacingOrder, isPlacingOrder) ||
                other.isPlacingOrder == isPlacingOrder) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.placedOrderId, placedOrderId) ||
                other.placedOrderId == placedOrderId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    loaderState,
    selectedAddress,
    isPlacingOrder,
    errorMessage,
    placedOrderId,
  );

  /// Create a copy of PrescriptionCheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrescriptionCheckoutStateImplCopyWith<_$PrescriptionCheckoutStateImpl>
  get copyWith =>
      __$$PrescriptionCheckoutStateImplCopyWithImpl<
        _$PrescriptionCheckoutStateImpl
      >(this, _$identity);
}

abstract class _PrescriptionCheckoutState implements PrescriptionCheckoutState {
  const factory _PrescriptionCheckoutState({
    final LoaderState loaderState,
    final AddressModel? selectedAddress,
    final bool isPlacingOrder,
    final String? errorMessage,
    final String? placedOrderId,
  }) = _$PrescriptionCheckoutStateImpl;

  @override
  LoaderState get loaderState;
  @override
  AddressModel? get selectedAddress;
  @override
  bool get isPlacingOrder;
  @override
  String? get errorMessage;
  @override
  String? get placedOrderId;

  /// Create a copy of PrescriptionCheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrescriptionCheckoutStateImplCopyWith<_$PrescriptionCheckoutStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}

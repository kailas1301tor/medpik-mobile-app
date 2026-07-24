// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CheckoutState {
  LoaderState get loaderState => throw _privateConstructorUsedError;
  AddressModel? get selectedAddress => throw _privateConstructorUsedError;
  String get pharmacistInstructions => throw _privateConstructorUsedError;
  bool get isPlacingOrder => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckoutStateCopyWith<CheckoutState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckoutStateCopyWith<$Res> {
  factory $CheckoutStateCopyWith(
    CheckoutState value,
    $Res Function(CheckoutState) then,
  ) = _$CheckoutStateCopyWithImpl<$Res, CheckoutState>;
  @useResult
  $Res call({
    LoaderState loaderState,
    AddressModel? selectedAddress,
    String pharmacistInstructions,
    bool isPlacingOrder,
    String? errorMessage,
  });
}

/// @nodoc
class _$CheckoutStateCopyWithImpl<$Res, $Val extends CheckoutState>
    implements $CheckoutStateCopyWith<$Res> {
  _$CheckoutStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loaderState = null,
    Object? selectedAddress = freezed,
    Object? pharmacistInstructions = null,
    Object? isPlacingOrder = null,
    Object? errorMessage = freezed,
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
            pharmacistInstructions: null == pharmacistInstructions
                ? _value.pharmacistInstructions
                : pharmacistInstructions // ignore: cast_nullable_to_non_nullable
                      as String,
            isPlacingOrder: null == isPlacingOrder
                ? _value.isPlacingOrder
                : isPlacingOrder // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$CheckoutStateImplCopyWith<$Res>
    implements $CheckoutStateCopyWith<$Res> {
  factory _$$CheckoutStateImplCopyWith(
    _$CheckoutStateImpl value,
    $Res Function(_$CheckoutStateImpl) then,
  ) = __$$CheckoutStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    LoaderState loaderState,
    AddressModel? selectedAddress,
    String pharmacistInstructions,
    bool isPlacingOrder,
    String? errorMessage,
  });
}

/// @nodoc
class __$$CheckoutStateImplCopyWithImpl<$Res>
    extends _$CheckoutStateCopyWithImpl<$Res, _$CheckoutStateImpl>
    implements _$$CheckoutStateImplCopyWith<$Res> {
  __$$CheckoutStateImplCopyWithImpl(
    _$CheckoutStateImpl _value,
    $Res Function(_$CheckoutStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loaderState = null,
    Object? selectedAddress = freezed,
    Object? pharmacistInstructions = null,
    Object? isPlacingOrder = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$CheckoutStateImpl(
        loaderState: null == loaderState
            ? _value.loaderState
            : loaderState // ignore: cast_nullable_to_non_nullable
                  as LoaderState,
        selectedAddress: freezed == selectedAddress
            ? _value.selectedAddress
            : selectedAddress // ignore: cast_nullable_to_non_nullable
                  as AddressModel?,
        pharmacistInstructions: null == pharmacistInstructions
            ? _value.pharmacistInstructions
            : pharmacistInstructions // ignore: cast_nullable_to_non_nullable
                  as String,
        isPlacingOrder: null == isPlacingOrder
            ? _value.isPlacingOrder
            : isPlacingOrder // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$CheckoutStateImpl implements _CheckoutState {
  const _$CheckoutStateImpl({
    this.loaderState = LoaderState.loaded,
    this.selectedAddress,
    this.pharmacistInstructions = '',
    this.isPlacingOrder = false,
    this.errorMessage,
  });

  @override
  @JsonKey()
  final LoaderState loaderState;
  @override
  final AddressModel? selectedAddress;
  @override
  @JsonKey()
  final String pharmacistInstructions;
  @override
  @JsonKey()
  final bool isPlacingOrder;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'CheckoutState(loaderState: $loaderState, selectedAddress: $selectedAddress, pharmacistInstructions: $pharmacistInstructions, isPlacingOrder: $isPlacingOrder, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckoutStateImpl &&
            (identical(other.loaderState, loaderState) ||
                other.loaderState == loaderState) &&
            (identical(other.selectedAddress, selectedAddress) ||
                other.selectedAddress == selectedAddress) &&
            (identical(other.pharmacistInstructions, pharmacistInstructions) ||
                other.pharmacistInstructions == pharmacistInstructions) &&
            (identical(other.isPlacingOrder, isPlacingOrder) ||
                other.isPlacingOrder == isPlacingOrder) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    loaderState,
    selectedAddress,
    pharmacistInstructions,
    isPlacingOrder,
    errorMessage,
  );

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckoutStateImplCopyWith<_$CheckoutStateImpl> get copyWith =>
      __$$CheckoutStateImplCopyWithImpl<_$CheckoutStateImpl>(this, _$identity);
}

abstract class _CheckoutState implements CheckoutState {
  const factory _CheckoutState({
    final LoaderState loaderState,
    final AddressModel? selectedAddress,
    final String pharmacistInstructions,
    final bool isPlacingOrder,
    final String? errorMessage,
  }) = _$CheckoutStateImpl;

  @override
  LoaderState get loaderState;
  @override
  AddressModel? get selectedAddress;
  @override
  String get pharmacistInstructions;
  @override
  bool get isPlacingOrder;
  @override
  String? get errorMessage;

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckoutStateImplCopyWith<_$CheckoutStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

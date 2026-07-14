// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CartState {
  LoaderState get loaderState => throw _privateConstructorUsedError;
  List<CartItemModel> get items => throw _privateConstructorUsedError;
  AddressModel? get selectedAddress => throw _privateConstructorUsedError;
  String get pharmacistInstructions => throw _privateConstructorUsedError;
  String? get submittedOrderId => throw _privateConstructorUsedError;

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartStateCopyWith<CartState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartStateCopyWith<$Res> {
  factory $CartStateCopyWith(CartState value, $Res Function(CartState) then) =
      _$CartStateCopyWithImpl<$Res, CartState>;
  @useResult
  $Res call({
    LoaderState loaderState,
    List<CartItemModel> items,
    AddressModel? selectedAddress,
    String pharmacistInstructions,
    String? submittedOrderId,
  });
}

/// @nodoc
class _$CartStateCopyWithImpl<$Res, $Val extends CartState>
    implements $CartStateCopyWith<$Res> {
  _$CartStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loaderState = null,
    Object? items = null,
    Object? selectedAddress = freezed,
    Object? pharmacistInstructions = null,
    Object? submittedOrderId = freezed,
  }) {
    return _then(
      _value.copyWith(
            loaderState: null == loaderState
                ? _value.loaderState
                : loaderState // ignore: cast_nullable_to_non_nullable
                      as LoaderState,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<CartItemModel>,
            selectedAddress: freezed == selectedAddress
                ? _value.selectedAddress
                : selectedAddress // ignore: cast_nullable_to_non_nullable
                      as AddressModel?,
            pharmacistInstructions: null == pharmacistInstructions
                ? _value.pharmacistInstructions
                : pharmacistInstructions // ignore: cast_nullable_to_non_nullable
                      as String,
            submittedOrderId: freezed == submittedOrderId
                ? _value.submittedOrderId
                : submittedOrderId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CartStateImplCopyWith<$Res>
    implements $CartStateCopyWith<$Res> {
  factory _$$CartStateImplCopyWith(
    _$CartStateImpl value,
    $Res Function(_$CartStateImpl) then,
  ) = __$$CartStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    LoaderState loaderState,
    List<CartItemModel> items,
    AddressModel? selectedAddress,
    String pharmacistInstructions,
    String? submittedOrderId,
  });
}

/// @nodoc
class __$$CartStateImplCopyWithImpl<$Res>
    extends _$CartStateCopyWithImpl<$Res, _$CartStateImpl>
    implements _$$CartStateImplCopyWith<$Res> {
  __$$CartStateImplCopyWithImpl(
    _$CartStateImpl _value,
    $Res Function(_$CartStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loaderState = null,
    Object? items = null,
    Object? selectedAddress = freezed,
    Object? pharmacistInstructions = null,
    Object? submittedOrderId = freezed,
  }) {
    return _then(
      _$CartStateImpl(
        loaderState: null == loaderState
            ? _value.loaderState
            : loaderState // ignore: cast_nullable_to_non_nullable
                  as LoaderState,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<CartItemModel>,
        selectedAddress: freezed == selectedAddress
            ? _value.selectedAddress
            : selectedAddress // ignore: cast_nullable_to_non_nullable
                  as AddressModel?,
        pharmacistInstructions: null == pharmacistInstructions
            ? _value.pharmacistInstructions
            : pharmacistInstructions // ignore: cast_nullable_to_non_nullable
                  as String,
        submittedOrderId: freezed == submittedOrderId
            ? _value.submittedOrderId
            : submittedOrderId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$CartStateImpl implements _CartState {
  const _$CartStateImpl({
    this.loaderState = LoaderState.loaded,
    final List<CartItemModel> items = const [],
    this.selectedAddress,
    this.pharmacistInstructions = '',
    this.submittedOrderId,
  }) : _items = items;

  @override
  @JsonKey()
  final LoaderState loaderState;
  final List<CartItemModel> _items;
  @override
  @JsonKey()
  List<CartItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final AddressModel? selectedAddress;
  @override
  @JsonKey()
  final String pharmacistInstructions;
  @override
  final String? submittedOrderId;

  @override
  String toString() {
    return 'CartState(loaderState: $loaderState, items: $items, selectedAddress: $selectedAddress, pharmacistInstructions: $pharmacistInstructions, submittedOrderId: $submittedOrderId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartStateImpl &&
            (identical(other.loaderState, loaderState) ||
                other.loaderState == loaderState) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.selectedAddress, selectedAddress) ||
                other.selectedAddress == selectedAddress) &&
            (identical(other.pharmacistInstructions, pharmacistInstructions) ||
                other.pharmacistInstructions == pharmacistInstructions) &&
            (identical(other.submittedOrderId, submittedOrderId) ||
                other.submittedOrderId == submittedOrderId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    loaderState,
    const DeepCollectionEquality().hash(_items),
    selectedAddress,
    pharmacistInstructions,
    submittedOrderId,
  );

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartStateImplCopyWith<_$CartStateImpl> get copyWith =>
      __$$CartStateImplCopyWithImpl<_$CartStateImpl>(this, _$identity);
}

abstract class _CartState implements CartState {
  const factory _CartState({
    final LoaderState loaderState,
    final List<CartItemModel> items,
    final AddressModel? selectedAddress,
    final String pharmacistInstructions,
    final String? submittedOrderId,
  }) = _$CartStateImpl;

  @override
  LoaderState get loaderState;
  @override
  List<CartItemModel> get items;
  @override
  AddressModel? get selectedAddress;
  @override
  String get pharmacistInstructions;
  @override
  String? get submittedOrderId;

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartStateImplCopyWith<_$CartStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

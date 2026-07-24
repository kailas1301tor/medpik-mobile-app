// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_general_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CustomerGeneralState {
  LoaderState get loaderState => throw _privateConstructorUsedError;
  CustomerGeneralDataModel? get data => throw _privateConstructorUsedError;

  /// Create a copy of CustomerGeneralState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerGeneralStateCopyWith<CustomerGeneralState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerGeneralStateCopyWith<$Res> {
  factory $CustomerGeneralStateCopyWith(
    CustomerGeneralState value,
    $Res Function(CustomerGeneralState) then,
  ) = _$CustomerGeneralStateCopyWithImpl<$Res, CustomerGeneralState>;
  @useResult
  $Res call({LoaderState loaderState, CustomerGeneralDataModel? data});
}

/// @nodoc
class _$CustomerGeneralStateCopyWithImpl<
  $Res,
  $Val extends CustomerGeneralState
>
    implements $CustomerGeneralStateCopyWith<$Res> {
  _$CustomerGeneralStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerGeneralState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? loaderState = null, Object? data = freezed}) {
    return _then(
      _value.copyWith(
            loaderState: null == loaderState
                ? _value.loaderState
                : loaderState // ignore: cast_nullable_to_non_nullable
                      as LoaderState,
            data: freezed == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as CustomerGeneralDataModel?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomerGeneralStateImplCopyWith<$Res>
    implements $CustomerGeneralStateCopyWith<$Res> {
  factory _$$CustomerGeneralStateImplCopyWith(
    _$CustomerGeneralStateImpl value,
    $Res Function(_$CustomerGeneralStateImpl) then,
  ) = __$$CustomerGeneralStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LoaderState loaderState, CustomerGeneralDataModel? data});
}

/// @nodoc
class __$$CustomerGeneralStateImplCopyWithImpl<$Res>
    extends _$CustomerGeneralStateCopyWithImpl<$Res, _$CustomerGeneralStateImpl>
    implements _$$CustomerGeneralStateImplCopyWith<$Res> {
  __$$CustomerGeneralStateImplCopyWithImpl(
    _$CustomerGeneralStateImpl _value,
    $Res Function(_$CustomerGeneralStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerGeneralState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? loaderState = null, Object? data = freezed}) {
    return _then(
      _$CustomerGeneralStateImpl(
        loaderState: null == loaderState
            ? _value.loaderState
            : loaderState // ignore: cast_nullable_to_non_nullable
                  as LoaderState,
        data: freezed == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as CustomerGeneralDataModel?,
      ),
    );
  }
}

/// @nodoc

class _$CustomerGeneralStateImpl implements _CustomerGeneralState {
  const _$CustomerGeneralStateImpl({
    this.loaderState = LoaderState.loaded,
    this.data,
  });

  @override
  @JsonKey()
  final LoaderState loaderState;
  @override
  final CustomerGeneralDataModel? data;

  @override
  String toString() {
    return 'CustomerGeneralState(loaderState: $loaderState, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerGeneralStateImpl &&
            (identical(other.loaderState, loaderState) ||
                other.loaderState == loaderState) &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, loaderState, data);

  /// Create a copy of CustomerGeneralState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerGeneralStateImplCopyWith<_$CustomerGeneralStateImpl>
  get copyWith =>
      __$$CustomerGeneralStateImplCopyWithImpl<_$CustomerGeneralStateImpl>(
        this,
        _$identity,
      );
}

abstract class _CustomerGeneralState implements CustomerGeneralState {
  const factory _CustomerGeneralState({
    final LoaderState loaderState,
    final CustomerGeneralDataModel? data,
  }) = _$CustomerGeneralStateImpl;

  @override
  LoaderState get loaderState;
  @override
  CustomerGeneralDataModel? get data;

  /// Create a copy of CustomerGeneralState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerGeneralStateImplCopyWith<_$CustomerGeneralStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}

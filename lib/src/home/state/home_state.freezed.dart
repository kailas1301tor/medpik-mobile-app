// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$HomeState {
  LoaderState get loaderState => throw _privateConstructorUsedError;
  HomeFeedModel? get data => throw _privateConstructorUsedError;
  CustomerGeneralDataModel? get generalData =>
      throw _privateConstructorUsedError;
  LoaderState get generalDataLoaderState => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  double get compactHeaderProgress => throw _privateConstructorUsedError;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeStateCopyWith<HomeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) then) =
      _$HomeStateCopyWithImpl<$Res, HomeState>;
  @useResult
  $Res call({
    LoaderState loaderState,
    HomeFeedModel? data,
    CustomerGeneralDataModel? generalData,
    LoaderState generalDataLoaderState,
    String? errorMessage,
    double compactHeaderProgress,
  });
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res, $Val extends HomeState>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loaderState = null,
    Object? data = freezed,
    Object? generalData = freezed,
    Object? generalDataLoaderState = null,
    Object? errorMessage = freezed,
    Object? compactHeaderProgress = null,
  }) {
    return _then(
      _value.copyWith(
            loaderState: null == loaderState
                ? _value.loaderState
                : loaderState // ignore: cast_nullable_to_non_nullable
                      as LoaderState,
            data: freezed == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as HomeFeedModel?,
            generalData: freezed == generalData
                ? _value.generalData
                : generalData // ignore: cast_nullable_to_non_nullable
                      as CustomerGeneralDataModel?,
            generalDataLoaderState: null == generalDataLoaderState
                ? _value.generalDataLoaderState
                : generalDataLoaderState // ignore: cast_nullable_to_non_nullable
                      as LoaderState,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            compactHeaderProgress: null == compactHeaderProgress
                ? _value.compactHeaderProgress
                : compactHeaderProgress // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HomeStateImplCopyWith<$Res>
    implements $HomeStateCopyWith<$Res> {
  factory _$$HomeStateImplCopyWith(
    _$HomeStateImpl value,
    $Res Function(_$HomeStateImpl) then,
  ) = __$$HomeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    LoaderState loaderState,
    HomeFeedModel? data,
    CustomerGeneralDataModel? generalData,
    LoaderState generalDataLoaderState,
    String? errorMessage,
    double compactHeaderProgress,
  });
}

/// @nodoc
class __$$HomeStateImplCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$HomeStateImpl>
    implements _$$HomeStateImplCopyWith<$Res> {
  __$$HomeStateImplCopyWithImpl(
    _$HomeStateImpl _value,
    $Res Function(_$HomeStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loaderState = null,
    Object? data = freezed,
    Object? generalData = freezed,
    Object? generalDataLoaderState = null,
    Object? errorMessage = freezed,
    Object? compactHeaderProgress = null,
  }) {
    return _then(
      _$HomeStateImpl(
        loaderState: null == loaderState
            ? _value.loaderState
            : loaderState // ignore: cast_nullable_to_non_nullable
                  as LoaderState,
        data: freezed == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as HomeFeedModel?,
        generalData: freezed == generalData
            ? _value.generalData
            : generalData // ignore: cast_nullable_to_non_nullable
                  as CustomerGeneralDataModel?,
        generalDataLoaderState: null == generalDataLoaderState
            ? _value.generalDataLoaderState
            : generalDataLoaderState // ignore: cast_nullable_to_non_nullable
                  as LoaderState,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        compactHeaderProgress: null == compactHeaderProgress
            ? _value.compactHeaderProgress
            : compactHeaderProgress // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$HomeStateImpl implements _HomeState {
  const _$HomeStateImpl({
    this.loaderState = LoaderState.loaded,
    this.data,
    this.generalData,
    this.generalDataLoaderState = LoaderState.loading,
    this.errorMessage,
    this.compactHeaderProgress = 0,
  });

  @override
  @JsonKey()
  final LoaderState loaderState;
  @override
  final HomeFeedModel? data;
  @override
  final CustomerGeneralDataModel? generalData;
  @override
  @JsonKey()
  final LoaderState generalDataLoaderState;
  @override
  final String? errorMessage;
  @override
  @JsonKey()
  final double compactHeaderProgress;

  @override
  String toString() {
    return 'HomeState(loaderState: $loaderState, data: $data, generalData: $generalData, generalDataLoaderState: $generalDataLoaderState, errorMessage: $errorMessage, compactHeaderProgress: $compactHeaderProgress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeStateImpl &&
            (identical(other.loaderState, loaderState) ||
                other.loaderState == loaderState) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.generalData, generalData) ||
                other.generalData == generalData) &&
            (identical(other.generalDataLoaderState, generalDataLoaderState) ||
                other.generalDataLoaderState == generalDataLoaderState) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.compactHeaderProgress, compactHeaderProgress) ||
                other.compactHeaderProgress == compactHeaderProgress));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    loaderState,
    data,
    generalData,
    generalDataLoaderState,
    errorMessage,
    compactHeaderProgress,
  );

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      __$$HomeStateImplCopyWithImpl<_$HomeStateImpl>(this, _$identity);
}

abstract class _HomeState implements HomeState {
  const factory _HomeState({
    final LoaderState loaderState,
    final HomeFeedModel? data,
    final CustomerGeneralDataModel? generalData,
    final LoaderState generalDataLoaderState,
    final String? errorMessage,
    final double compactHeaderProgress,
  }) = _$HomeStateImpl;

  @override
  LoaderState get loaderState;
  @override
  HomeFeedModel? get data;
  @override
  CustomerGeneralDataModel? get generalData;
  @override
  LoaderState get generalDataLoaderState;
  @override
  String? get errorMessage;
  @override
  double get compactHeaderProgress;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

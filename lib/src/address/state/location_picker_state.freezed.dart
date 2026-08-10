// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_picker_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LocationPickerState {
  LoaderState get loaderState => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  ReverseGeocodeResult? get reverseResult => throw _privateConstructorUsedError;
  bool get isSearching => throw _privateConstructorUsedError;
  bool get isReverseLoading => throw _privateConstructorUsedError;
  bool get isInitialCameraReady => throw _privateConstructorUsedError;
  bool get isServiceable => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  String? get searchErrorMessage => throw _privateConstructorUsedError;
  PickedLocationModel? get confirmedPick => throw _privateConstructorUsedError;

  /// Create a copy of LocationPickerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationPickerStateCopyWith<LocationPickerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationPickerStateCopyWith<$Res> {
  factory $LocationPickerStateCopyWith(
    LocationPickerState value,
    $Res Function(LocationPickerState) then,
  ) = _$LocationPickerStateCopyWithImpl<$Res, LocationPickerState>;
  @useResult
  $Res call({
    LoaderState loaderState,
    double latitude,
    double longitude,
    ReverseGeocodeResult? reverseResult,
    bool isSearching,
    bool isReverseLoading,
    bool isInitialCameraReady,
    bool isServiceable,
    String? errorMessage,
    String? searchErrorMessage,
    PickedLocationModel? confirmedPick,
  });
}

/// @nodoc
class _$LocationPickerStateCopyWithImpl<$Res, $Val extends LocationPickerState>
    implements $LocationPickerStateCopyWith<$Res> {
  _$LocationPickerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationPickerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loaderState = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? reverseResult = freezed,
    Object? isSearching = null,
    Object? isReverseLoading = null,
    Object? isInitialCameraReady = null,
    Object? isServiceable = null,
    Object? errorMessage = freezed,
    Object? searchErrorMessage = freezed,
    Object? confirmedPick = freezed,
  }) {
    return _then(
      _value.copyWith(
            loaderState: null == loaderState
                ? _value.loaderState
                : loaderState // ignore: cast_nullable_to_non_nullable
                      as LoaderState,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            reverseResult: freezed == reverseResult
                ? _value.reverseResult
                : reverseResult // ignore: cast_nullable_to_non_nullable
                      as ReverseGeocodeResult?,
            isSearching: null == isSearching
                ? _value.isSearching
                : isSearching // ignore: cast_nullable_to_non_nullable
                      as bool,
            isReverseLoading: null == isReverseLoading
                ? _value.isReverseLoading
                : isReverseLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isInitialCameraReady: null == isInitialCameraReady
                ? _value.isInitialCameraReady
                : isInitialCameraReady // ignore: cast_nullable_to_non_nullable
                      as bool,
            isServiceable: null == isServiceable
                ? _value.isServiceable
                : isServiceable // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            searchErrorMessage: freezed == searchErrorMessage
                ? _value.searchErrorMessage
                : searchErrorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            confirmedPick: freezed == confirmedPick
                ? _value.confirmedPick
                : confirmedPick // ignore: cast_nullable_to_non_nullable
                      as PickedLocationModel?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LocationPickerStateImplCopyWith<$Res>
    implements $LocationPickerStateCopyWith<$Res> {
  factory _$$LocationPickerStateImplCopyWith(
    _$LocationPickerStateImpl value,
    $Res Function(_$LocationPickerStateImpl) then,
  ) = __$$LocationPickerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    LoaderState loaderState,
    double latitude,
    double longitude,
    ReverseGeocodeResult? reverseResult,
    bool isSearching,
    bool isReverseLoading,
    bool isInitialCameraReady,
    bool isServiceable,
    String? errorMessage,
    String? searchErrorMessage,
    PickedLocationModel? confirmedPick,
  });
}

/// @nodoc
class __$$LocationPickerStateImplCopyWithImpl<$Res>
    extends _$LocationPickerStateCopyWithImpl<$Res, _$LocationPickerStateImpl>
    implements _$$LocationPickerStateImplCopyWith<$Res> {
  __$$LocationPickerStateImplCopyWithImpl(
    _$LocationPickerStateImpl _value,
    $Res Function(_$LocationPickerStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LocationPickerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loaderState = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? reverseResult = freezed,
    Object? isSearching = null,
    Object? isReverseLoading = null,
    Object? isInitialCameraReady = null,
    Object? isServiceable = null,
    Object? errorMessage = freezed,
    Object? searchErrorMessage = freezed,
    Object? confirmedPick = freezed,
  }) {
    return _then(
      _$LocationPickerStateImpl(
        loaderState: null == loaderState
            ? _value.loaderState
            : loaderState // ignore: cast_nullable_to_non_nullable
                  as LoaderState,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        reverseResult: freezed == reverseResult
            ? _value.reverseResult
            : reverseResult // ignore: cast_nullable_to_non_nullable
                  as ReverseGeocodeResult?,
        isSearching: null == isSearching
            ? _value.isSearching
            : isSearching // ignore: cast_nullable_to_non_nullable
                  as bool,
        isReverseLoading: null == isReverseLoading
            ? _value.isReverseLoading
            : isReverseLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isInitialCameraReady: null == isInitialCameraReady
            ? _value.isInitialCameraReady
            : isInitialCameraReady // ignore: cast_nullable_to_non_nullable
                  as bool,
        isServiceable: null == isServiceable
            ? _value.isServiceable
            : isServiceable // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        searchErrorMessage: freezed == searchErrorMessage
            ? _value.searchErrorMessage
            : searchErrorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        confirmedPick: freezed == confirmedPick
            ? _value.confirmedPick
            : confirmedPick // ignore: cast_nullable_to_non_nullable
                  as PickedLocationModel?,
      ),
    );
  }
}

/// @nodoc

class _$LocationPickerStateImpl implements _LocationPickerState {
  const _$LocationPickerStateImpl({
    this.loaderState = LoaderState.loaded,
    this.latitude = LocationConfig.defaultLat,
    this.longitude = LocationConfig.defaultLng,
    this.reverseResult,
    this.isSearching = false,
    this.isReverseLoading = false,
    this.isInitialCameraReady = false,
    this.isServiceable = false,
    this.errorMessage,
    this.searchErrorMessage,
    this.confirmedPick,
  });

  @override
  @JsonKey()
  final LoaderState loaderState;
  @override
  @JsonKey()
  final double latitude;
  @override
  @JsonKey()
  final double longitude;
  @override
  final ReverseGeocodeResult? reverseResult;
  @override
  @JsonKey()
  final bool isSearching;
  @override
  @JsonKey()
  final bool isReverseLoading;
  @override
  @JsonKey()
  final bool isInitialCameraReady;
  @override
  @JsonKey()
  final bool isServiceable;
  @override
  final String? errorMessage;
  @override
  final String? searchErrorMessage;
  @override
  final PickedLocationModel? confirmedPick;

  @override
  String toString() {
    return 'LocationPickerState(loaderState: $loaderState, latitude: $latitude, longitude: $longitude, reverseResult: $reverseResult, isSearching: $isSearching, isReverseLoading: $isReverseLoading, isInitialCameraReady: $isInitialCameraReady, isServiceable: $isServiceable, errorMessage: $errorMessage, searchErrorMessage: $searchErrorMessage, confirmedPick: $confirmedPick)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationPickerStateImpl &&
            (identical(other.loaderState, loaderState) ||
                other.loaderState == loaderState) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.reverseResult, reverseResult) ||
                other.reverseResult == reverseResult) &&
            (identical(other.isSearching, isSearching) ||
                other.isSearching == isSearching) &&
            (identical(other.isReverseLoading, isReverseLoading) ||
                other.isReverseLoading == isReverseLoading) &&
            (identical(other.isInitialCameraReady, isInitialCameraReady) ||
                other.isInitialCameraReady == isInitialCameraReady) &&
            (identical(other.isServiceable, isServiceable) ||
                other.isServiceable == isServiceable) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.searchErrorMessage, searchErrorMessage) ||
                other.searchErrorMessage == searchErrorMessage) &&
            (identical(other.confirmedPick, confirmedPick) ||
                other.confirmedPick == confirmedPick));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    loaderState,
    latitude,
    longitude,
    reverseResult,
    isSearching,
    isReverseLoading,
    isInitialCameraReady,
    isServiceable,
    errorMessage,
    searchErrorMessage,
    confirmedPick,
  );

  /// Create a copy of LocationPickerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationPickerStateImplCopyWith<_$LocationPickerStateImpl> get copyWith =>
      __$$LocationPickerStateImplCopyWithImpl<_$LocationPickerStateImpl>(
        this,
        _$identity,
      );
}

abstract class _LocationPickerState implements LocationPickerState {
  const factory _LocationPickerState({
    final LoaderState loaderState,
    final double latitude,
    final double longitude,
    final ReverseGeocodeResult? reverseResult,
    final bool isSearching,
    final bool isReverseLoading,
    final bool isInitialCameraReady,
    final bool isServiceable,
    final String? errorMessage,
    final String? searchErrorMessage,
    final PickedLocationModel? confirmedPick,
  }) = _$LocationPickerStateImpl;

  @override
  LoaderState get loaderState;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  ReverseGeocodeResult? get reverseResult;
  @override
  bool get isSearching;
  @override
  bool get isReverseLoading;
  @override
  bool get isInitialCameraReady;
  @override
  bool get isServiceable;
  @override
  String? get errorMessage;
  @override
  String? get searchErrorMessage;
  @override
  PickedLocationModel? get confirmedPick;

  /// Create a copy of LocationPickerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationPickerStateImplCopyWith<_$LocationPickerStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

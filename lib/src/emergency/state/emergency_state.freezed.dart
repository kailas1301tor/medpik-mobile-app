// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'emergency_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$EmergencyState {
  LoaderState get loaderState => throw _privateConstructorUsedError;
  bool get isAmbulancesEmpty => throw _privateConstructorUsedError;
  bool get isDoctorsEmpty => throw _privateConstructorUsedError;
  List<EmergencyAmbulanceModel> get ambulances =>
      throw _privateConstructorUsedError;
  List<EmergencyDoctorModel> get doctors => throw _privateConstructorUsedError;

  /// Create a copy of EmergencyState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmergencyStateCopyWith<EmergencyState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmergencyStateCopyWith<$Res> {
  factory $EmergencyStateCopyWith(
    EmergencyState value,
    $Res Function(EmergencyState) then,
  ) = _$EmergencyStateCopyWithImpl<$Res, EmergencyState>;
  @useResult
  $Res call({
    LoaderState loaderState,
    bool isAmbulancesEmpty,
    bool isDoctorsEmpty,
    List<EmergencyAmbulanceModel> ambulances,
    List<EmergencyDoctorModel> doctors,
  });
}

/// @nodoc
class _$EmergencyStateCopyWithImpl<$Res, $Val extends EmergencyState>
    implements $EmergencyStateCopyWith<$Res> {
  _$EmergencyStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmergencyState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loaderState = null,
    Object? isAmbulancesEmpty = null,
    Object? isDoctorsEmpty = null,
    Object? ambulances = null,
    Object? doctors = null,
  }) {
    return _then(
      _value.copyWith(
            loaderState: null == loaderState
                ? _value.loaderState
                : loaderState // ignore: cast_nullable_to_non_nullable
                      as LoaderState,
            isAmbulancesEmpty: null == isAmbulancesEmpty
                ? _value.isAmbulancesEmpty
                : isAmbulancesEmpty // ignore: cast_nullable_to_non_nullable
                      as bool,
            isDoctorsEmpty: null == isDoctorsEmpty
                ? _value.isDoctorsEmpty
                : isDoctorsEmpty // ignore: cast_nullable_to_non_nullable
                      as bool,
            ambulances: null == ambulances
                ? _value.ambulances
                : ambulances // ignore: cast_nullable_to_non_nullable
                      as List<EmergencyAmbulanceModel>,
            doctors: null == doctors
                ? _value.doctors
                : doctors // ignore: cast_nullable_to_non_nullable
                      as List<EmergencyDoctorModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EmergencyStateImplCopyWith<$Res>
    implements $EmergencyStateCopyWith<$Res> {
  factory _$$EmergencyStateImplCopyWith(
    _$EmergencyStateImpl value,
    $Res Function(_$EmergencyStateImpl) then,
  ) = __$$EmergencyStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    LoaderState loaderState,
    bool isAmbulancesEmpty,
    bool isDoctorsEmpty,
    List<EmergencyAmbulanceModel> ambulances,
    List<EmergencyDoctorModel> doctors,
  });
}

/// @nodoc
class __$$EmergencyStateImplCopyWithImpl<$Res>
    extends _$EmergencyStateCopyWithImpl<$Res, _$EmergencyStateImpl>
    implements _$$EmergencyStateImplCopyWith<$Res> {
  __$$EmergencyStateImplCopyWithImpl(
    _$EmergencyStateImpl _value,
    $Res Function(_$EmergencyStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmergencyState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loaderState = null,
    Object? isAmbulancesEmpty = null,
    Object? isDoctorsEmpty = null,
    Object? ambulances = null,
    Object? doctors = null,
  }) {
    return _then(
      _$EmergencyStateImpl(
        loaderState: null == loaderState
            ? _value.loaderState
            : loaderState // ignore: cast_nullable_to_non_nullable
                  as LoaderState,
        isAmbulancesEmpty: null == isAmbulancesEmpty
            ? _value.isAmbulancesEmpty
            : isAmbulancesEmpty // ignore: cast_nullable_to_non_nullable
                  as bool,
        isDoctorsEmpty: null == isDoctorsEmpty
            ? _value.isDoctorsEmpty
            : isDoctorsEmpty // ignore: cast_nullable_to_non_nullable
                  as bool,
        ambulances: null == ambulances
            ? _value._ambulances
            : ambulances // ignore: cast_nullable_to_non_nullable
                  as List<EmergencyAmbulanceModel>,
        doctors: null == doctors
            ? _value._doctors
            : doctors // ignore: cast_nullable_to_non_nullable
                  as List<EmergencyDoctorModel>,
      ),
    );
  }
}

/// @nodoc

class _$EmergencyStateImpl implements _EmergencyState {
  const _$EmergencyStateImpl({
    this.loaderState = LoaderState.loading,
    this.isAmbulancesEmpty = false,
    this.isDoctorsEmpty = false,
    final List<EmergencyAmbulanceModel> ambulances = const [],
    final List<EmergencyDoctorModel> doctors = const [],
  }) : _ambulances = ambulances,
       _doctors = doctors;

  @override
  @JsonKey()
  final LoaderState loaderState;
  @override
  @JsonKey()
  final bool isAmbulancesEmpty;
  @override
  @JsonKey()
  final bool isDoctorsEmpty;
  final List<EmergencyAmbulanceModel> _ambulances;
  @override
  @JsonKey()
  List<EmergencyAmbulanceModel> get ambulances {
    if (_ambulances is EqualUnmodifiableListView) return _ambulances;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ambulances);
  }

  final List<EmergencyDoctorModel> _doctors;
  @override
  @JsonKey()
  List<EmergencyDoctorModel> get doctors {
    if (_doctors is EqualUnmodifiableListView) return _doctors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_doctors);
  }

  @override
  String toString() {
    return 'EmergencyState(loaderState: $loaderState, isAmbulancesEmpty: $isAmbulancesEmpty, isDoctorsEmpty: $isDoctorsEmpty, ambulances: $ambulances, doctors: $doctors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmergencyStateImpl &&
            (identical(other.loaderState, loaderState) ||
                other.loaderState == loaderState) &&
            (identical(other.isAmbulancesEmpty, isAmbulancesEmpty) ||
                other.isAmbulancesEmpty == isAmbulancesEmpty) &&
            (identical(other.isDoctorsEmpty, isDoctorsEmpty) ||
                other.isDoctorsEmpty == isDoctorsEmpty) &&
            const DeepCollectionEquality().equals(
              other._ambulances,
              _ambulances,
            ) &&
            const DeepCollectionEquality().equals(other._doctors, _doctors));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    loaderState,
    isAmbulancesEmpty,
    isDoctorsEmpty,
    const DeepCollectionEquality().hash(_ambulances),
    const DeepCollectionEquality().hash(_doctors),
  );

  /// Create a copy of EmergencyState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmergencyStateImplCopyWith<_$EmergencyStateImpl> get copyWith =>
      __$$EmergencyStateImplCopyWithImpl<_$EmergencyStateImpl>(
        this,
        _$identity,
      );
}

abstract class _EmergencyState implements EmergencyState {
  const factory _EmergencyState({
    final LoaderState loaderState,
    final bool isAmbulancesEmpty,
    final bool isDoctorsEmpty,
    final List<EmergencyAmbulanceModel> ambulances,
    final List<EmergencyDoctorModel> doctors,
  }) = _$EmergencyStateImpl;

  @override
  LoaderState get loaderState;
  @override
  bool get isAmbulancesEmpty;
  @override
  bool get isDoctorsEmpty;
  @override
  List<EmergencyAmbulanceModel> get ambulances;
  @override
  List<EmergencyDoctorModel> get doctors;

  /// Create a copy of EmergencyState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmergencyStateImplCopyWith<_$EmergencyStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ProfileState {
  LoaderState get loaderState => throw _privateConstructorUsedError;
  ProfileModel? get profile => throw _privateConstructorUsedError;
  bool get isSaving => throw _privateConstructorUsedError;
  bool get isProfileFormValid => throw _privateConstructorUsedError;
  String? get firstNameError => throw _privateConstructorUsedError;
  String? get lastNameError => throw _privateConstructorUsedError;

  /// Create a copy of ProfileState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileStateCopyWith<ProfileState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileStateCopyWith<$Res> {
  factory $ProfileStateCopyWith(
    ProfileState value,
    $Res Function(ProfileState) then,
  ) = _$ProfileStateCopyWithImpl<$Res, ProfileState>;
  @useResult
  $Res call({
    LoaderState loaderState,
    ProfileModel? profile,
    bool isSaving,
    bool isProfileFormValid,
    String? firstNameError,
    String? lastNameError,
  });
}

/// @nodoc
class _$ProfileStateCopyWithImpl<$Res, $Val extends ProfileState>
    implements $ProfileStateCopyWith<$Res> {
  _$ProfileStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loaderState = null,
    Object? profile = freezed,
    Object? isSaving = null,
    Object? isProfileFormValid = null,
    Object? firstNameError = freezed,
    Object? lastNameError = freezed,
  }) {
    return _then(
      _value.copyWith(
            loaderState: null == loaderState
                ? _value.loaderState
                : loaderState // ignore: cast_nullable_to_non_nullable
                      as LoaderState,
            profile: freezed == profile
                ? _value.profile
                : profile // ignore: cast_nullable_to_non_nullable
                      as ProfileModel?,
            isSaving: null == isSaving
                ? _value.isSaving
                : isSaving // ignore: cast_nullable_to_non_nullable
                      as bool,
            isProfileFormValid: null == isProfileFormValid
                ? _value.isProfileFormValid
                : isProfileFormValid // ignore: cast_nullable_to_non_nullable
                      as bool,
            firstNameError: freezed == firstNameError
                ? _value.firstNameError
                : firstNameError // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastNameError: freezed == lastNameError
                ? _value.lastNameError
                : lastNameError // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProfileStateImplCopyWith<$Res>
    implements $ProfileStateCopyWith<$Res> {
  factory _$$ProfileStateImplCopyWith(
    _$ProfileStateImpl value,
    $Res Function(_$ProfileStateImpl) then,
  ) = __$$ProfileStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    LoaderState loaderState,
    ProfileModel? profile,
    bool isSaving,
    bool isProfileFormValid,
    String? firstNameError,
    String? lastNameError,
  });
}

/// @nodoc
class __$$ProfileStateImplCopyWithImpl<$Res>
    extends _$ProfileStateCopyWithImpl<$Res, _$ProfileStateImpl>
    implements _$$ProfileStateImplCopyWith<$Res> {
  __$$ProfileStateImplCopyWithImpl(
    _$ProfileStateImpl _value,
    $Res Function(_$ProfileStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProfileState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loaderState = null,
    Object? profile = freezed,
    Object? isSaving = null,
    Object? isProfileFormValid = null,
    Object? firstNameError = freezed,
    Object? lastNameError = freezed,
  }) {
    return _then(
      _$ProfileStateImpl(
        loaderState: null == loaderState
            ? _value.loaderState
            : loaderState // ignore: cast_nullable_to_non_nullable
                  as LoaderState,
        profile: freezed == profile
            ? _value.profile
            : profile // ignore: cast_nullable_to_non_nullable
                  as ProfileModel?,
        isSaving: null == isSaving
            ? _value.isSaving
            : isSaving // ignore: cast_nullable_to_non_nullable
                  as bool,
        isProfileFormValid: null == isProfileFormValid
            ? _value.isProfileFormValid
            : isProfileFormValid // ignore: cast_nullable_to_non_nullable
                  as bool,
        firstNameError: freezed == firstNameError
            ? _value.firstNameError
            : firstNameError // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastNameError: freezed == lastNameError
            ? _value.lastNameError
            : lastNameError // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$ProfileStateImpl implements _ProfileState {
  const _$ProfileStateImpl({
    this.loaderState = LoaderState.loaded,
    this.profile,
    this.isSaving = false,
    this.isProfileFormValid = false,
    this.firstNameError,
    this.lastNameError,
  });

  @override
  @JsonKey()
  final LoaderState loaderState;
  @override
  final ProfileModel? profile;
  @override
  @JsonKey()
  final bool isSaving;
  @override
  @JsonKey()
  final bool isProfileFormValid;
  @override
  final String? firstNameError;
  @override
  final String? lastNameError;

  @override
  String toString() {
    return 'ProfileState(loaderState: $loaderState, profile: $profile, isSaving: $isSaving, isProfileFormValid: $isProfileFormValid, firstNameError: $firstNameError, lastNameError: $lastNameError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileStateImpl &&
            (identical(other.loaderState, loaderState) ||
                other.loaderState == loaderState) &&
            (identical(other.profile, profile) || other.profile == profile) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.isProfileFormValid, isProfileFormValid) ||
                other.isProfileFormValid == isProfileFormValid) &&
            (identical(other.firstNameError, firstNameError) ||
                other.firstNameError == firstNameError) &&
            (identical(other.lastNameError, lastNameError) ||
                other.lastNameError == lastNameError));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    loaderState,
    profile,
    isSaving,
    isProfileFormValid,
    firstNameError,
    lastNameError,
  );

  /// Create a copy of ProfileState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileStateImplCopyWith<_$ProfileStateImpl> get copyWith =>
      __$$ProfileStateImplCopyWithImpl<_$ProfileStateImpl>(this, _$identity);
}

abstract class _ProfileState implements ProfileState {
  const factory _ProfileState({
    final LoaderState loaderState,
    final ProfileModel? profile,
    final bool isSaving,
    final bool isProfileFormValid,
    final String? firstNameError,
    final String? lastNameError,
  }) = _$ProfileStateImpl;

  @override
  LoaderState get loaderState;
  @override
  ProfileModel? get profile;
  @override
  bool get isSaving;
  @override
  bool get isProfileFormValid;
  @override
  String? get firstNameError;
  @override
  String? get lastNameError;

  /// Create a copy of ProfileState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileStateImplCopyWith<_$ProfileStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

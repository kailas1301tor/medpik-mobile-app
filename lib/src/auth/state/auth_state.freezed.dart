// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AuthState {
  AuthModel? get authModel => throw _privateConstructorUsedError;
  String? get otpPhone => throw _privateConstructorUsedError;
  String? get phoneErrorText => throw _privateConstructorUsedError;
  String? get otpErrorMessage => throw _privateConstructorUsedError;
  bool get isPhoneValid => throw _privateConstructorUsedError;
  bool get isOtpValid => throw _privateConstructorUsedError;
  bool get isRequestingOtp => throw _privateConstructorUsedError;
  bool get isVerifyingOtp => throw _privateConstructorUsedError;
  bool get isSigningOut => throw _privateConstructorUsedError;
  int get resendCountdown => throw _privateConstructorUsedError;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthStateCopyWith<AuthState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
  @useResult
  $Res call({
    AuthModel? authModel,
    String? otpPhone,
    String? phoneErrorText,
    String? otpErrorMessage,
    bool isPhoneValid,
    bool isOtpValid,
    bool isRequestingOtp,
    bool isVerifyingOtp,
    bool isSigningOut,
    int resendCountdown,
  });
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authModel = freezed,
    Object? otpPhone = freezed,
    Object? phoneErrorText = freezed,
    Object? otpErrorMessage = freezed,
    Object? isPhoneValid = null,
    Object? isOtpValid = null,
    Object? isRequestingOtp = null,
    Object? isVerifyingOtp = null,
    Object? isSigningOut = null,
    Object? resendCountdown = null,
  }) {
    return _then(
      _value.copyWith(
            authModel: freezed == authModel
                ? _value.authModel
                : authModel // ignore: cast_nullable_to_non_nullable
                      as AuthModel?,
            otpPhone: freezed == otpPhone
                ? _value.otpPhone
                : otpPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            phoneErrorText: freezed == phoneErrorText
                ? _value.phoneErrorText
                : phoneErrorText // ignore: cast_nullable_to_non_nullable
                      as String?,
            otpErrorMessage: freezed == otpErrorMessage
                ? _value.otpErrorMessage
                : otpErrorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            isPhoneValid: null == isPhoneValid
                ? _value.isPhoneValid
                : isPhoneValid // ignore: cast_nullable_to_non_nullable
                      as bool,
            isOtpValid: null == isOtpValid
                ? _value.isOtpValid
                : isOtpValid // ignore: cast_nullable_to_non_nullable
                      as bool,
            isRequestingOtp: null == isRequestingOtp
                ? _value.isRequestingOtp
                : isRequestingOtp // ignore: cast_nullable_to_non_nullable
                      as bool,
            isVerifyingOtp: null == isVerifyingOtp
                ? _value.isVerifyingOtp
                : isVerifyingOtp // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSigningOut: null == isSigningOut
                ? _value.isSigningOut
                : isSigningOut // ignore: cast_nullable_to_non_nullable
                      as bool,
            resendCountdown: null == resendCountdown
                ? _value.resendCountdown
                : resendCountdown // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AuthStateImplCopyWith<$Res>
    implements $AuthStateCopyWith<$Res> {
  factory _$$AuthStateImplCopyWith(
    _$AuthStateImpl value,
    $Res Function(_$AuthStateImpl) then,
  ) = __$$AuthStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    AuthModel? authModel,
    String? otpPhone,
    String? phoneErrorText,
    String? otpErrorMessage,
    bool isPhoneValid,
    bool isOtpValid,
    bool isRequestingOtp,
    bool isVerifyingOtp,
    bool isSigningOut,
    int resendCountdown,
  });
}

/// @nodoc
class __$$AuthStateImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthStateImpl>
    implements _$$AuthStateImplCopyWith<$Res> {
  __$$AuthStateImplCopyWithImpl(
    _$AuthStateImpl _value,
    $Res Function(_$AuthStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authModel = freezed,
    Object? otpPhone = freezed,
    Object? phoneErrorText = freezed,
    Object? otpErrorMessage = freezed,
    Object? isPhoneValid = null,
    Object? isOtpValid = null,
    Object? isRequestingOtp = null,
    Object? isVerifyingOtp = null,
    Object? isSigningOut = null,
    Object? resendCountdown = null,
  }) {
    return _then(
      _$AuthStateImpl(
        authModel: freezed == authModel
            ? _value.authModel
            : authModel // ignore: cast_nullable_to_non_nullable
                  as AuthModel?,
        otpPhone: freezed == otpPhone
            ? _value.otpPhone
            : otpPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        phoneErrorText: freezed == phoneErrorText
            ? _value.phoneErrorText
            : phoneErrorText // ignore: cast_nullable_to_non_nullable
                  as String?,
        otpErrorMessage: freezed == otpErrorMessage
            ? _value.otpErrorMessage
            : otpErrorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        isPhoneValid: null == isPhoneValid
            ? _value.isPhoneValid
            : isPhoneValid // ignore: cast_nullable_to_non_nullable
                  as bool,
        isOtpValid: null == isOtpValid
            ? _value.isOtpValid
            : isOtpValid // ignore: cast_nullable_to_non_nullable
                  as bool,
        isRequestingOtp: null == isRequestingOtp
            ? _value.isRequestingOtp
            : isRequestingOtp // ignore: cast_nullable_to_non_nullable
                  as bool,
        isVerifyingOtp: null == isVerifyingOtp
            ? _value.isVerifyingOtp
            : isVerifyingOtp // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSigningOut: null == isSigningOut
            ? _value.isSigningOut
            : isSigningOut // ignore: cast_nullable_to_non_nullable
                  as bool,
        resendCountdown: null == resendCountdown
            ? _value.resendCountdown
            : resendCountdown // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$AuthStateImpl implements _AuthState {
  const _$AuthStateImpl({
    this.authModel,
    this.otpPhone,
    this.phoneErrorText,
    this.otpErrorMessage,
    this.isPhoneValid = false,
    this.isOtpValid = false,
    this.isRequestingOtp = false,
    this.isVerifyingOtp = false,
    this.isSigningOut = false,
    this.resendCountdown = 0,
  });

  @override
  final AuthModel? authModel;
  @override
  final String? otpPhone;
  @override
  final String? phoneErrorText;
  @override
  final String? otpErrorMessage;
  @override
  @JsonKey()
  final bool isPhoneValid;
  @override
  @JsonKey()
  final bool isOtpValid;
  @override
  @JsonKey()
  final bool isRequestingOtp;
  @override
  @JsonKey()
  final bool isVerifyingOtp;
  @override
  @JsonKey()
  final bool isSigningOut;
  @override
  @JsonKey()
  final int resendCountdown;

  @override
  String toString() {
    return 'AuthState(authModel: $authModel, otpPhone: $otpPhone, phoneErrorText: $phoneErrorText, otpErrorMessage: $otpErrorMessage, isPhoneValid: $isPhoneValid, isOtpValid: $isOtpValid, isRequestingOtp: $isRequestingOtp, isVerifyingOtp: $isVerifyingOtp, isSigningOut: $isSigningOut, resendCountdown: $resendCountdown)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthStateImpl &&
            (identical(other.authModel, authModel) ||
                other.authModel == authModel) &&
            (identical(other.otpPhone, otpPhone) ||
                other.otpPhone == otpPhone) &&
            (identical(other.phoneErrorText, phoneErrorText) ||
                other.phoneErrorText == phoneErrorText) &&
            (identical(other.otpErrorMessage, otpErrorMessage) ||
                other.otpErrorMessage == otpErrorMessage) &&
            (identical(other.isPhoneValid, isPhoneValid) ||
                other.isPhoneValid == isPhoneValid) &&
            (identical(other.isOtpValid, isOtpValid) ||
                other.isOtpValid == isOtpValid) &&
            (identical(other.isRequestingOtp, isRequestingOtp) ||
                other.isRequestingOtp == isRequestingOtp) &&
            (identical(other.isVerifyingOtp, isVerifyingOtp) ||
                other.isVerifyingOtp == isVerifyingOtp) &&
            (identical(other.isSigningOut, isSigningOut) ||
                other.isSigningOut == isSigningOut) &&
            (identical(other.resendCountdown, resendCountdown) ||
                other.resendCountdown == resendCountdown));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    authModel,
    otpPhone,
    phoneErrorText,
    otpErrorMessage,
    isPhoneValid,
    isOtpValid,
    isRequestingOtp,
    isVerifyingOtp,
    isSigningOut,
    resendCountdown,
  );

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthStateImplCopyWith<_$AuthStateImpl> get copyWith =>
      __$$AuthStateImplCopyWithImpl<_$AuthStateImpl>(this, _$identity);
}

abstract class _AuthState implements AuthState {
  const factory _AuthState({
    final AuthModel? authModel,
    final String? otpPhone,
    final String? phoneErrorText,
    final String? otpErrorMessage,
    final bool isPhoneValid,
    final bool isOtpValid,
    final bool isRequestingOtp,
    final bool isVerifyingOtp,
    final bool isSigningOut,
    final int resendCountdown,
  }) = _$AuthStateImpl;

  @override
  AuthModel? get authModel;
  @override
  String? get otpPhone;
  @override
  String? get phoneErrorText;
  @override
  String? get otpErrorMessage;
  @override
  bool get isPhoneValid;
  @override
  bool get isOtpValid;
  @override
  bool get isRequestingOtp;
  @override
  bool get isVerifyingOtp;
  @override
  bool get isSigningOut;
  @override
  int get resendCountdown;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthStateImplCopyWith<_$AuthStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

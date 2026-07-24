// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notifications_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$NotificationsState {
  LoaderState get loaderState => throw _privateConstructorUsedError;
  List<NotificationModel> get notifications =>
      throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  bool get isLoadingMore => throw _privateConstructorUsedError;
  bool get isMarkAllReadLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of NotificationsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationsStateCopyWith<NotificationsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationsStateCopyWith<$Res> {
  factory $NotificationsStateCopyWith(
    NotificationsState value,
    $Res Function(NotificationsState) then,
  ) = _$NotificationsStateCopyWithImpl<$Res, NotificationsState>;
  @useResult
  $Res call({
    LoaderState loaderState,
    List<NotificationModel> notifications,
    int currentPage,
    bool hasMore,
    bool isLoadingMore,
    bool isMarkAllReadLoading,
    String? errorMessage,
  });
}

/// @nodoc
class _$NotificationsStateCopyWithImpl<$Res, $Val extends NotificationsState>
    implements $NotificationsStateCopyWith<$Res> {
  _$NotificationsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loaderState = null,
    Object? notifications = null,
    Object? currentPage = null,
    Object? hasMore = null,
    Object? isLoadingMore = null,
    Object? isMarkAllReadLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            loaderState: null == loaderState
                ? _value.loaderState
                : loaderState // ignore: cast_nullable_to_non_nullable
                      as LoaderState,
            notifications: null == notifications
                ? _value.notifications
                : notifications // ignore: cast_nullable_to_non_nullable
                      as List<NotificationModel>,
            currentPage: null == currentPage
                ? _value.currentPage
                : currentPage // ignore: cast_nullable_to_non_nullable
                      as int,
            hasMore: null == hasMore
                ? _value.hasMore
                : hasMore // ignore: cast_nullable_to_non_nullable
                      as bool,
            isLoadingMore: null == isLoadingMore
                ? _value.isLoadingMore
                : isLoadingMore // ignore: cast_nullable_to_non_nullable
                      as bool,
            isMarkAllReadLoading: null == isMarkAllReadLoading
                ? _value.isMarkAllReadLoading
                : isMarkAllReadLoading // ignore: cast_nullable_to_non_nullable
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
abstract class _$$NotificationsStateImplCopyWith<$Res>
    implements $NotificationsStateCopyWith<$Res> {
  factory _$$NotificationsStateImplCopyWith(
    _$NotificationsStateImpl value,
    $Res Function(_$NotificationsStateImpl) then,
  ) = __$$NotificationsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    LoaderState loaderState,
    List<NotificationModel> notifications,
    int currentPage,
    bool hasMore,
    bool isLoadingMore,
    bool isMarkAllReadLoading,
    String? errorMessage,
  });
}

/// @nodoc
class __$$NotificationsStateImplCopyWithImpl<$Res>
    extends _$NotificationsStateCopyWithImpl<$Res, _$NotificationsStateImpl>
    implements _$$NotificationsStateImplCopyWith<$Res> {
  __$$NotificationsStateImplCopyWithImpl(
    _$NotificationsStateImpl _value,
    $Res Function(_$NotificationsStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loaderState = null,
    Object? notifications = null,
    Object? currentPage = null,
    Object? hasMore = null,
    Object? isLoadingMore = null,
    Object? isMarkAllReadLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$NotificationsStateImpl(
        loaderState: null == loaderState
            ? _value.loaderState
            : loaderState // ignore: cast_nullable_to_non_nullable
                  as LoaderState,
        notifications: null == notifications
            ? _value._notifications
            : notifications // ignore: cast_nullable_to_non_nullable
                  as List<NotificationModel>,
        currentPage: null == currentPage
            ? _value.currentPage
            : currentPage // ignore: cast_nullable_to_non_nullable
                  as int,
        hasMore: null == hasMore
            ? _value.hasMore
            : hasMore // ignore: cast_nullable_to_non_nullable
                  as bool,
        isLoadingMore: null == isLoadingMore
            ? _value.isLoadingMore
            : isLoadingMore // ignore: cast_nullable_to_non_nullable
                  as bool,
        isMarkAllReadLoading: null == isMarkAllReadLoading
            ? _value.isMarkAllReadLoading
            : isMarkAllReadLoading // ignore: cast_nullable_to_non_nullable
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

class _$NotificationsStateImpl implements _NotificationsState {
  const _$NotificationsStateImpl({
    this.loaderState = LoaderState.loaded,
    final List<NotificationModel> notifications = const [],
    this.currentPage = 0,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.isMarkAllReadLoading = false,
    this.errorMessage,
  }) : _notifications = notifications;

  @override
  @JsonKey()
  final LoaderState loaderState;
  final List<NotificationModel> _notifications;
  @override
  @JsonKey()
  List<NotificationModel> get notifications {
    if (_notifications is EqualUnmodifiableListView) return _notifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notifications);
  }

  @override
  @JsonKey()
  final int currentPage;
  @override
  @JsonKey()
  final bool hasMore;
  @override
  @JsonKey()
  final bool isLoadingMore;
  @override
  @JsonKey()
  final bool isMarkAllReadLoading;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'NotificationsState(loaderState: $loaderState, notifications: $notifications, currentPage: $currentPage, hasMore: $hasMore, isLoadingMore: $isLoadingMore, isMarkAllReadLoading: $isMarkAllReadLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationsStateImpl &&
            (identical(other.loaderState, loaderState) ||
                other.loaderState == loaderState) &&
            const DeepCollectionEquality().equals(
              other._notifications,
              _notifications,
            ) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.isMarkAllReadLoading, isMarkAllReadLoading) ||
                other.isMarkAllReadLoading == isMarkAllReadLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    loaderState,
    const DeepCollectionEquality().hash(_notifications),
    currentPage,
    hasMore,
    isLoadingMore,
    isMarkAllReadLoading,
    errorMessage,
  );

  /// Create a copy of NotificationsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationsStateImplCopyWith<_$NotificationsStateImpl> get copyWith =>
      __$$NotificationsStateImplCopyWithImpl<_$NotificationsStateImpl>(
        this,
        _$identity,
      );
}

abstract class _NotificationsState implements NotificationsState {
  const factory _NotificationsState({
    final LoaderState loaderState,
    final List<NotificationModel> notifications,
    final int currentPage,
    final bool hasMore,
    final bool isLoadingMore,
    final bool isMarkAllReadLoading,
    final String? errorMessage,
  }) = _$NotificationsStateImpl;

  @override
  LoaderState get loaderState;
  @override
  List<NotificationModel> get notifications;
  @override
  int get currentPage;
  @override
  bool get hasMore;
  @override
  bool get isLoadingMore;
  @override
  bool get isMarkAllReadLoading;
  @override
  String? get errorMessage;

  /// Create a copy of NotificationsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationsStateImplCopyWith<_$NotificationsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

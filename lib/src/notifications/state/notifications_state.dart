// lib/src/notifications/state/notifications_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/src/notifications/model/notification_model.dart';

part 'notifications_state.freezed.dart';

@freezed
sealed class NotificationsState with _$NotificationsState {
  const factory NotificationsState({
    @Default(LoaderState.loaded) LoaderState loaderState,
    @Default([]) List<NotificationModel> notifications,
    @Default(0) int currentPage,
    @Default(false) bool hasMore,
    @Default(false) bool isLoadingMore,
    @Default(false) bool isMarkAllReadLoading,
    String? errorMessage,
  }) = _NotificationsState;
}

// lib/src/notifications/state/notifications_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/src/notifications/model/notification_model.dart';

part 'notifications_state.freezed.dart';

@freezed
sealed class NotificationsState with _$NotificationsState {
  const factory NotificationsState({
    @Default(LoaderState.loaded) LoaderState loaderState,
    @Default([]) List<NotificationModel> notifications,
    String? errorMessage,
  }) = _NotificationsState;
}

// lib/src/notifications/notifier/notifications_notifier.dart
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/services/repo_di.dart';
import 'package:tsuite/src/notifications/repo/notifications_repository.dart';
import 'package:tsuite/src/notifications/state/notifications_state.dart';
import 'package:tsuite/utils/helpers/api_error_handler.dart';

part 'notifications_notifier.g.dart';

@Riverpod(keepAlive: false)
class NotificationsNotifier extends _$NotificationsNotifier {
  late NotificationsRepo notificationsRepo;

  @override
  NotificationsState build() {
    notificationsRepo = ref.read(notificationsRepositoryProvider);
    Future.microtask(fetchNotifications);
    return const NotificationsState(loaderState: LoaderState.loading);
  }

  Future<void> fetchNotifications() async {
    state = state.copyWith(loaderState: LoaderState.loading);

    return await notificationsRepo
        .getNotifications()
        .fold(
          (left) {
            final loaderState = handleResponseError(left.key);
            debugPrint("🔴 NOTIFICATIONS ERROR: ${left.message}");
            state = state.copyWith(loaderState: loaderState);
          },
          (notifications) {
            debugPrint(
              "🟢 NOTIFICATIONS SUCCESS: ${notifications.length} items",
            );
            state = state.copyWith(
              loaderState: notifications.isEmpty
                  ? LoaderState.noData
                  : LoaderState.loaded,
              notifications: notifications,
            );
          },
        )
        .catchError((e) {
          debugPrint("🔴 UNEXPECTED NOTIFICATIONS ERROR: $e");
          state = state.copyWith(loaderState: LoaderState.error);
        });
  }

  Future<void> markAsRead(int id) async {
    return await notificationsRepo
        .markAsRead(id)
        .fold(
          (left) {
            debugPrint("🔴 MARK READ ERROR: ${left.message}");
          },
          (_) {
            final updated = state.notifications
                .map((n) => n.id == id ? n.copyWith(isRead: true) : n)
                .toList();
            state = state.copyWith(notifications: updated);
            debugPrint("🟢 MARK READ SUCCESS: id=$id");
          },
        )
        .catchError((e) {
          debugPrint("🔴 UNEXPECTED MARK READ ERROR: $e");
        });
  }

  Future<void> markAllAsRead() async {
    return await notificationsRepo
        .markAllAsRead()
        .fold(
          (left) {
            debugPrint("🔴 MARK ALL READ ERROR: ${left.message}");
          },
          (_) {
            final updated = state.notifications
                .map((n) => n.copyWith(isRead: true))
                .toList();
            state = state.copyWith(notifications: updated);
            debugPrint("🟢 MARK ALL READ SUCCESS");
          },
        )
        .catchError((e) {
          debugPrint("🔴 UNEXPECTED MARK ALL READ ERROR: $e");
        });
  }
}

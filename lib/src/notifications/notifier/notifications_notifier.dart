// lib/src/notifications/notifier/notifications_notifier.dart
import 'package:either_dart/either.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/services/repo_di.dart';
import 'package:medpik/src/notifications/repo/notifications_repository.dart';
import 'package:medpik/src/notifications/state/notifications_state.dart';
import 'package:medpik/utils/helpers/api_error_handler.dart';
import 'package:medpik/utils/helpers/toast_helper.dart';

part 'notifications_notifier.g.dart';

@Riverpod(keepAlive: false)
class NotificationsNotifier extends _$NotificationsNotifier {
  static const int _pageSize = 10;

  late NotificationsRepo notificationsRepo;
  int _requestId = 0;

  @override
  NotificationsState build() {
    notificationsRepo = ref.read(notificationsRepositoryProvider);
    Future.microtask(() => fetchNotifications(page: 1));
    return const NotificationsState(loaderState: LoaderState.loading);
  }




// ! ----------------------------- API CALLS -----------------------------

// This function is used to fetch the notifications from the API.
  Future<void> fetchNotifications({
    required int page,
    bool append = false,
  }) async {
    final requestId = ++_requestId;

    if (append) {
      if (!state.hasMore || state.isLoadingMore) return;
      state = state.copyWith(isLoadingMore: true, errorMessage: null);
    } else {
      state = state.copyWith(
        loaderState: LoaderState.loading,
        errorMessage: null,
        notifications: const [],
        currentPage: 0,
        hasMore: false,
        isLoadingMore: false,
      );
    }

    return await notificationsRepo
        .getNotifications(page: page, pageSize: _pageSize)
        .fold(
          (left) {
            if (requestId != _requestId) return;
            final loaderState = handleResponseError(left.key);
            state = state.copyWith(
              loaderState: append ? state.loaderState : loaderState,
              isLoadingMore: false,
              errorMessage: left.message,
              notifications: append ? state.notifications : const [],
            );
          },
          (response) {
            if (requestId != _requestId) return;

            final pageNotifications = response.notifications;
            final merged = append
                ? [...state.notifications, ...pageNotifications]
                : pageNotifications;
            final hasMore = pageNotifications.isEmpty
                ? false
                : response.hasMore;

            state = state.copyWith(
              loaderState: merged.isEmpty
                  ? LoaderState.noData
                  : LoaderState.loaded,
              notifications: merged,
              currentPage: response.currentPage > 0
                  ? response.currentPage
                  : page,
              hasMore: hasMore,
              isLoadingMore: false,
            );
          },
        )
        .catchError((e) {
          if (requestId != _requestId) return;
          state = state.copyWith(
            loaderState: append ? state.loaderState : LoaderState.error,
            isLoadingMore: false,
            notifications: append ? state.notifications : const [],
          );
        });
  }



// to mark all notifications as read
  Future<void> markAllAsRead() async {
    if (state.isMarkAllReadLoading) return;

    state = state.copyWith(isMarkAllReadLoading: true);
    await notificationsRepo
        .markAllAsRead()
        .fold(
          (left) {
            showCustomToast(
              message: left.message ?? Strings.somethingWentWrong,
              isSuccess: false,
            );
          },
          (right) {
            final updated = state.notifications
                .map((n) => n.copyWith(isRead: true))
                .toList();
            state = state.copyWith(notifications: updated);
            showCustomToast(
              message: "All notifications marked as read",
              isSuccess: true,
            );
          },
        )
        .catchError((e) {
          showCustomToast(
            message: Strings.somethingWentWrong,
            isSuccess: false,
          );
        });
    state = state.copyWith(isMarkAllReadLoading: false);
  }



  // ! ----------------------------- HELPER FUNCTIONS -----------------------------

  // to load more notifications
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) return;
    await fetchNotifications(page: state.currentPage + 1, append: true);
  }
}

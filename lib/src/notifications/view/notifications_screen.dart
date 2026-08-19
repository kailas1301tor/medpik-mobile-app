// lib/src/notifications/view/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medpik/res/constants/assets.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/src/notifications/model/notification_model.dart';
import 'package:medpik/src/notifications/notifier/notifications_notifier.dart';
import 'package:medpik/src/notifications/view/widget/notifications_content_widget.dart';
import 'package:medpik/src/notifications/view/widget/notifications_screen_header.dart';
import 'package:medpik/src/notifications/view/widget/notifications_shimmer_widget.dart';
import 'package:medpik/utils/common_widgets/common_refresh_indicator.dart';
import 'package:medpik/utils/common_widgets/common_scaffold.dart';
import 'package:medpik/utils/common_widgets/common_switch_state.dart';
import 'package:medpik/utils/helpers/notification_navigation_helper.dart';
import 'package:tuple/tuple.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  void _onNotificationTap(
    BuildContext context,
    NotificationModel notification,
  ) {
    final payload = notification.data;
    if (payload != null) {
      navigateFromNotificationPayload(context, payload);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final loaderState = ref.watch(
      notificationsNotifierProvider.select((s) => s.loaderState),
    );
    final notifier = ref.read(notificationsNotifierProvider.notifier);

    return CommonScaffold(
      backgroundColor: colors.background,
      body: CommonRefreshIndicator(
        onRefresh: () => notifier.fetchNotifications(page: 1),
        child: Column(
          children: [
            const _NotificationsHeaderScope(),
            Expanded(
              child: CommonSwitchState(
                loaderState: loaderState,
                reload: () => notifier.fetchNotifications(page: 1),
                loader: const NotificationsShimmerWidget(),
                buttonText: Strings.refresh,
                emptyScreenTitle: Strings.noNotifications,
                emptyScreenDescription: Strings.noNotificationsDesc,
                emptyScreenImage: Assets.pngNoNotification,
                child: _NotificationsContentScope(
                  onNotificationTap: (notification) =>
                      _onNotificationTap(context, notification),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationsHeaderScope extends ConsumerWidget {
  const _NotificationsHeaderScope();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final headerData = ref.watch(
      notificationsNotifierProvider.select(
        (s) => Tuple2(
          s.notifications.any((n) => !n.isRead),
          s.isMarkAllReadLoading,
        ),
      ),
    );

    return NotificationsScreenHeader(
      showMarkAllRead: headerData.item1,
      isMarkAllReadLoading: headerData.item2,
      onMarkAllRead: ref
          .read(notificationsNotifierProvider.notifier)
          .markAllAsRead,
    );
  }
}

class _NotificationsContentScope extends ConsumerWidget {
  const _NotificationsContentScope({required this.onNotificationTap});

  final ValueChanged<NotificationModel> onNotificationTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentData = ref.watch(
      notificationsNotifierProvider.select(
        (s) => Tuple3(s.notifications, s.hasMore, s.isLoadingMore),
      ),
    );

    return NotificationsContentWidget(
      notifications: contentData.item1,
      hasMore: contentData.item2,
      isLoadingMore: contentData.item3,
      onLoadMore: ref.read(notificationsNotifierProvider.notifier).loadMore,
      onNotificationTap: onNotificationTap,
    );
  }
}

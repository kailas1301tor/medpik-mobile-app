// lib/src/notifications/view/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuite/res/constants/assets.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/src/notifications/notifier/notifications_notifier.dart';
import 'package:tsuite/src/notifications/view/widget/notifications_content_widget.dart';
import 'package:tsuite/src/notifications/view/widget/notifications_screen_header.dart';
import 'package:tsuite/utils/common_widgets/common_refresh_indicator.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';
import 'package:tsuite/utils/common_widgets/common_switch_state.dart';
import 'package:tuple/tuple.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final notificationsData = ref.watch(
      notificationsNotifierProvider.select(
        (s) => Tuple2(s.loaderState, s.notifications),
      ),
    );
    final loaderState = notificationsData.item1;
    final notifications = notificationsData.item2;
    final hasUnread = notifications.any((n) => !n.isRead);
    final notifier = ref.read(notificationsNotifierProvider.notifier);

    return CommonScaffold(
      backgroundColor: colors.background,
      body: CommonRefreshIndicator(
        onRefresh: notifier.fetchNotifications,
        child: Column(
          children: [
            NotificationsScreenHeader(
              showMarkAllRead: hasUnread,
              onMarkAllRead: notifier.markAllAsRead,
            ),
            Expanded(
              child: CommonSwitchState(
                loaderState: loaderState,
                reload: notifier.fetchNotifications,
                buttonText: Strings.refresh,
                emptyScreenTitle: Strings.noNotifications,
                emptyScreenDescription: Strings.noNotificationsDesc,
                emptyScreenImage: Assets.iconsNoNotification,
                child: NotificationsContentWidget(
                  notifications: notifications,
                  onNotificationTap: (notification) {
                    if (!notification.isRead) {
                      notifier.markAsRead(notification.id);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

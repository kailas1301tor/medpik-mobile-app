// lib/src/notifications/view/widget/notifications_content_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/src/notifications/model/notification_model.dart';
import 'package:tsuite/src/notifications/view/widget/notification_tile.dart';

class NotificationsContentWidget extends StatelessWidget {
  const NotificationsContentWidget({
    super.key,
    required this.notifications,
    required this.onNotificationTap,
  });

  final List<NotificationModel> notifications;
  final ValueChanged<NotificationModel> onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
      itemCount: notifications.length,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return NotificationTile(
          notification: notification,
          onTap: () => onNotificationTap(notification),
        );
      },
    );
  }
}

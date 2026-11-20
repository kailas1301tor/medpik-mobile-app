// lib/src/notifications/view/widget/notifications_content_widget.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/src/notifications/model/notification_model.dart';
import 'package:medpik/src/notifications/view/widget/notification_tile.dart';
import 'package:medpik/utils/helpers/pagination_scroll_helper.dart';

class NotificationsContentWidget extends StatelessWidget {
  const NotificationsContentWidget({
    super.key,
    required this.notifications,
    required this.hasMore,
    required this.isLoadingMore,
    required this.onNotificationTap,
    required this.onLoadMore,
  });

  final List<NotificationModel> notifications;
  final bool hasMore;
  final bool isLoadingMore;
  final ValueChanged<NotificationModel> onNotificationTap;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    return PaginationScrollListener(
      hasMore: hasMore,
      isLoadingMore: isLoadingMore,
      onLoadMore: onLoadMore,
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
        itemCount: notifications.length + 1,
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
        itemBuilder: (context, index) {
          if (index == notifications.length) {
            if (isLoadingMore) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Center(
                  child: CupertinoActivityIndicator(radius: 10.r),
                ),
              );
            }
            return SizedBox(height: 16.h);
          }

          final notification = notifications[index];
          return NotificationTile(
            notification: notification,
            onTap: () => onNotificationTap(notification),
          );
        },
      ),
    );
  }
}

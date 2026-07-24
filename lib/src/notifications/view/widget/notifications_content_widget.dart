// lib/src/notifications/view/widget/notifications_content_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/notifications/model/notification_model.dart';
import 'package:medpik/src/notifications/view/widget/notification_tile.dart';
import 'package:medpik/utils/common_widgets/common_loader.dart';

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
    final colors = context.appColors;

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
      itemCount: notifications.length + 1,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      itemBuilder: (context, index) {
        if (index == notifications.length) {
          if (isLoadingMore) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: CommonLoader(size: 24.r, color: colors.primary),
            );
          }
          if (hasMore && notifications.isNotEmpty) {
            return GestureDetector(
              onTap: onLoadMore,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.refresh,
                      size: 18.r,
                      color: colors.primary,
                    ),
                    6.horizontalSpace,
                    Text(
                      Strings.loadMore,
                      style: FontPalette.base600(13, color: colors.primary),
                    ),
                  ],
                ),
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
    );
  }
}

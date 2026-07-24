// lib/src/notifications/view/widget/notification_tile.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/notifications/model/notification_model.dart';
import 'package:medpik/utils/common_widgets/common_cached_network_image.dart';
import 'package:medpik/utils/common_widgets/common_container.dart';
import 'package:medpik/utils/helpers/order_status_helper.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final NotificationModel notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isUnread = !notification.isRead;
    final imageUrl = notification.image?.trim() ?? '';

    return CommonContainer(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.r),
      borderRadius: 16.r,
      color: isUnread
          ? colors.primary.withValues(alpha: 0.08)
          : colors.surface,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageUrl.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: CommonCachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 40.r,
                    height: 40.r,
                    borderRadius: 12.r,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    _iconForType(notification.type),
                    size: 20.r,
                    color: colors.primary,
                  ),
                ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: FontPalette.base600(
                          14,
                          color: colors.primaryText,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isUnread) ...[
                      8.horizontalSpace,
                      Container(
                        width: 8.r,
                        height: 8.r,
                        margin: EdgeInsets.only(top: 4.h),
                        decoration: BoxDecoration(
                          color: colors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
                4.verticalSpace,
                Text(
                  notification.body,
                  style: FontPalette.base400(13, color: colors.secondaryText),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                8.verticalSpace,
                Text(
                  formatOrderDateTime(notification.createdAt),
                  style: FontPalette.base400(11, color: colors.secondaryText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForType(NotificationType type) {
    return switch (type) {
      NotificationType.order => Icons.local_shipping_outlined,
      NotificationType.prescription => Icons.description_outlined,
      NotificationType.offer => Icons.local_offer_outlined,
      NotificationType.system => Icons.notifications_outlined,
    };
  }
}

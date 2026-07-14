// lib/src/notifications/view/widget/notifications_screen_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';

class NotificationsScreenHeader extends StatelessWidget {
  const NotificationsScreenHeader({
    super.key,
    required this.showMarkAllRead,
    required this.onMarkAllRead,
  });

  final bool showMarkAllRead;
  final VoidCallback onMarkAllRead;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(8.w, 8.h, 16.w, 16.h),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20.r,
                color: colors.primaryText,
              ),
            ),
            Expanded(
              child: Text(
                Strings.notifications,
                style: FontPalette.base700(24, color: colors.primaryText),
              ),
            ),
            if (showMarkAllRead)
              GestureDetector(
                onTap: onMarkAllRead,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
                  child: Text(
                    Strings.markAllAsRead,
                    style: FontPalette.base600(13, color: colors.primary),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

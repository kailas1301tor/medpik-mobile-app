// lib/src/notifications/view/widget/notifications_screen_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/utils/common_widgets/common_back_button.dart';
import 'package:medpik/utils/common_widgets/common_shimmer_box.dart';

class NotificationsScreenHeader extends StatelessWidget {
  const NotificationsScreenHeader({
    super.key,
    required this.showMarkAllRead,
    required this.isMarkAllReadLoading,
    required this.onMarkAllRead,
  });

  final bool showMarkAllRead;
  final bool isMarkAllReadLoading;
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
            const CommonBackButton(),
            Expanded(
              child: Text(
                Strings.notifications,
                style: FontPalette.base700(24, color: colors.primaryText),
              ),
            ),
            if (showMarkAllRead || isMarkAllReadLoading)
              GestureDetector(
                onTap: isMarkAllReadLoading ? null : onMarkAllRead,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
                  child: isMarkAllReadLoading
                      ? CommonShimmerBox(
                          height: 14.h,
                          width: 88.w,
                          borderRadius: 6.r,
                        )
                      : Text(
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

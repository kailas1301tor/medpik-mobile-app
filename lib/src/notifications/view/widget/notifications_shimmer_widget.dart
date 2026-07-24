// lib/src/notifications/view/widget/notifications_shimmer_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/utils/common_widgets/common_container.dart';
import 'package:medpik/utils/common_widgets/common_shimmer_box.dart';

class NotificationsShimmerWidget extends StatelessWidget {
  const NotificationsShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      separatorBuilder: (_, __) => 12.verticalSpace,
      itemBuilder: (_, __) {
        return CommonContainer(
          padding: EdgeInsets.all(16.r),
          borderRadius: 16.r,
          color: colors.surface,
          side: BorderSide(color: colors.cardBorder, width: 1.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonShimmerBox(height: 44.r, width: 44.r, borderRadius: 12.r),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonShimmerBox(
                      height: 14.h,
                      width: double.infinity,
                      borderRadius: 6.r,
                    ),
                    8.verticalSpace,
                    CommonShimmerBox(
                      height: 12.h,
                      width: 220.w,
                      borderRadius: 6.r,
                    ),
                    8.verticalSpace,
                    CommonShimmerBox(
                      height: 10.h,
                      width: 80.w,
                      borderRadius: 6.r,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

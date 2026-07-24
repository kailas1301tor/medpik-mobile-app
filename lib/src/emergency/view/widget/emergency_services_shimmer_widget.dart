// lib/src/emergency/view/widget/emergency_services_shimmer_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/utils/common_widgets/common_container.dart';
import 'package:medpik/utils/common_widgets/common_shimmer_box.dart';

class EmergencyServicesShimmerWidget extends StatelessWidget {
  const EmergencyServicesShimmerWidget({super.key});

  static const int _itemCount = 4;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _itemCount,
      itemBuilder: (context, index) {
        return CommonContainer(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.r),
          borderRadius: 16.r,
          color: colors.surface,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonShimmerBox(
                height: 40.r,
                width: 40.r,
                borderRadius: 20.r,
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonShimmerBox(
                      height: 16.h,
                      width: 140.w,
                      borderRadius: 6.r,
                    ),
                    6.verticalSpace,
                    CommonShimmerBox(
                      height: 12.h,
                      width: 100.w,
                      borderRadius: 6.r,
                    ),
                    6.verticalSpace,
                    CommonShimmerBox(
                      height: 12.h,
                      width: double.infinity,
                      borderRadius: 6.r,
                    ),
                    6.verticalSpace,
                    CommonShimmerBox(
                      height: 12.h,
                      width: 120.w,
                      borderRadius: 6.r,
                    ),
                  ],
                ),
              ),
              8.horizontalSpace,
              CommonShimmerBox(
                height: 36.r,
                width: 36.r,
                borderRadius: 18.r,
              ),
            ],
          ),
        );
      },
    );
  }
}

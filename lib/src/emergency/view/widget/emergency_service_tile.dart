// lib/src/emergency/view/widget/emergency_service_tile.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medpik/res/constants/medpik_svg_assets.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/emergency/view/widget/emergency_service_badge.dart';
import 'package:medpik/utils/common_widgets/common_container.dart';
import 'package:medpik/utils/helpers/phone_launch_helper.dart';

class EmergencyServiceTile extends StatelessWidget {
  const EmergencyServiceTile({
    super.key,
    required this.name,
    required this.phoneNumber,
    required this.locationLine,
    required this.leadingIcon,
    this.designation,
  });

  final String name;
  final String phoneNumber;
  final String locationLine;
  final IconData leadingIcon;
  final String? designation;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return CommonContainer(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      borderRadius: 16.r,
      color: colors.surface,
      side: BorderSide.none,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EmergencyServiceBadge(icon: leadingIcon),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: FontPalette.base700(16, color: colors.primaryText),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (designation != null && designation!.isNotEmpty) ...[
                  4.verticalSpace,
                  Text(
                    designation!,
                    style: FontPalette.base500(13, color: colors.primary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (locationLine.isNotEmpty) ...[
                  6.verticalSpace,
                  Text(
                    locationLine,
                    style: FontPalette.base400(13, color: colors.secondaryText),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (phoneNumber.isNotEmpty) ...[
                  6.verticalSpace,
                  Text(
                    phoneNumber,
                    style: FontPalette.base500(14, color: colors.primaryText),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          8.horizontalSpace,
          Material(
            color: ColorPalette.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(999.r),
              onTap: phoneNumber.isEmpty
                  ? null
                  : () => launchPhoneCall(phoneNumber),
              child: Container(
                height: 36.r,
                width: 36.r,
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.24),
                      blurRadius: 12.r,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  MedpikSvgAssets.phone,
                  width: 18.r,
                  height: 18.r,
                  colorFilter: ColorFilter.mode(
                    ColorPalette.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

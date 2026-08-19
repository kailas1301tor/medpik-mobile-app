// lib/src/address/view/widget/location_access_banner.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/services/location/location_access_status.dart';
import 'package:medpik/utils/common_widgets/common_container.dart';

class LocationAccessBanner extends StatelessWidget {
  const LocationAccessBanner({
    super.key,
    required this.status,
    required this.onAction,
  });

  final LocationAccessStatus status;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final message = switch (status) {
      LocationAccessStatus.servicesDisabled => Strings.locationServicesDisabled,
      LocationAccessStatus.permissionDenied =>
        Strings.locationPermissionRationale,
      LocationAccessStatus.permissionDeniedForever =>
        Strings.locationPermissionBlocked,
      LocationAccessStatus.granted => '',
    };
    final actionLabel = switch (status) {
      LocationAccessStatus.servicesDisabled => Strings.locationEnableServices,
      LocationAccessStatus.permissionDenied => Strings.locationAllowAccess,
      LocationAccessStatus.permissionDeniedForever =>
        Strings.locationOpenSettings,
      LocationAccessStatus.granted => Strings.useCurrentLocation,
    };

    return CommonContainer(
      padding: EdgeInsets.all(12.r),
      borderRadius: 12.r,
      color: colors.inputBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: FontPalette.base400(12, color: colors.secondaryText),
          ),
          8.verticalSpace,
          GestureDetector(
            onTap: onAction,
            behavior: HitTestBehavior.opaque,
            child: Text(
              actionLabel,
              style: FontPalette.base600(13, color: colors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

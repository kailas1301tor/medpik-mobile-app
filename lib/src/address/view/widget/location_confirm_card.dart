// lib/src/address/view/widget/location_confirm_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/services/location/geocode_client.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';
import 'package:tsuite/utils/common_widgets/common_inline_loader.dart';
import 'package:tsuite/utils/common_widgets/primary_button.dart';

class LocationConfirmCard extends StatelessWidget {
  const LocationConfirmCard({
    super.key,
    required this.result,
    required this.isLoading,
    required this.isServiceable,
    required this.errorMessage,
    required this.onUseCurrentLocation,
    required this.onConfirm,
  });

  final ReverseGeocodeResult? result;
  final bool isLoading;
  final bool isServiceable;
  final String? errorMessage;
  final VoidCallback onUseCurrentLocation;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final title = result?.formattedAddress.isNotEmpty == true
        ? result!.formattedAddress
        : Strings.selectLocationOnMap;

    return CommonContainer(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      borderRadius: 20.r,
      color: colors.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onUseCurrentLocation,
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Icon(Icons.my_location, size: 18.r, color: colors.primary),
                8.horizontalSpace,
                Text(
                  Strings.useCurrentLocation,
                  style: FontPalette.base600(13, color: colors.primary),
                ),
              ],
            ),
          ),
          12.verticalSpace,
          if (isLoading)
            Row(
              children: [
                CommonInlineLoader(size: 16.r, color: colors.primary),
                10.horizontalSpace,
                Text(
                  Strings.fetchingAddress,
                  style: FontPalette.base400(13, color: colors.secondaryText),
                ),
              ],
            )
          else ...[
            Text(
              Strings.deliveryLocation,
              style: FontPalette.base500(12, color: colors.secondaryText),
            ),
            4.verticalSpace,
            Text(
              title,
              style: FontPalette.base600(15, color: colors.primaryText),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (errorMessage != null) ...[
              8.verticalSpace,
              Text(
                errorMessage!,
                style: FontPalette.base400(12, color: colors.errorText),
              ),
            ],
          ],
          16.verticalSpace,
          PrimaryButton(
            text: Strings.confirmLocation,
            onPressed: isServiceable && result != null && !isLoading
                ? onConfirm
                : null,
          ),
        ],
      ),
    );
  }
}

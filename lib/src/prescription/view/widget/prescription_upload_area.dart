// lib/src/prescription/view/widget/prescription_upload_area.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medpik/res/constants/medpik_svg_assets.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/utils/common_widgets/dashed_border_container.dart';

class PrescriptionUploadArea extends StatelessWidget {
  const PrescriptionUploadArea({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return DashedBorderContainer(
      height: 180.h,
      borderRadius: 16,
      dashWidth: 6,
      dashGap: 6,
      strokeWidth: 2,
      borderColor: isDarkMode
          ? colors.inputBorder
          : ColorPalette.prescriptionUploadDashedBorder,
      backgroundColor: isDarkMode
          ? colors.inputBackground
          : ColorPalette.prescriptionUploadAreaBg,
      onTap: onTap,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              MedpikSvgAssets.arrowCircleUp,
              width: 56.r,
              height: 56.r,
            ),
            12.verticalSpace,
            Text(
              Strings.uploadPrescriptionTapHint,
              style: FontPalette.base600(14, color: colors.primaryText),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

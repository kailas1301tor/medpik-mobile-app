// lib/src/prescription/view/widget/prescription_add_more_tile.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medpik/res/constants/medpik_svg_assets.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/utils/common_widgets/dashed_border_container.dart';

class PrescriptionAddMoreTile extends StatelessWidget {
  const PrescriptionAddMoreTile({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return DashedBorderContainer(
      width: 96.w,
      height: 96.w,
      borderRadius: 14,
      dashWidth: 5,
      dashGap: 5,
      strokeWidth: 2,
      borderColor: isDarkMode
          ? colors.inputBorder
          : ColorPalette.prescriptionUploadDashedBorder,
      backgroundColor: colors.inputBackground,
      onTap: onTap,
      padding: EdgeInsets.all(8.r),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              MedpikSvgAssets.arrowCircleUp,
              width: 30.r,
              height: 30.r,
            ),
            6.verticalSpace,
            Text(
              Strings.addMore,
              style: FontPalette.base600(11, color: colors.primaryText),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

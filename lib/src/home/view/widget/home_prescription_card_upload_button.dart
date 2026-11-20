// lib/src/home/view/widget/home_prescription_card_upload_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';

class HomePrescriptionCardUploadButton extends StatelessWidget {
  const HomePrescriptionCardUploadButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(100.r);

    return Material(
      color: ColorPalette.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        splashColor: ColorPalette.white.withValues(alpha: 0.18),
        highlightColor: ColorPalette.white.withValues(alpha: 0.08),
        child: Ink(
          height: 40.h,
          decoration: BoxDecoration(
            color: ColorPalette.prescriptionUploadBtn,
            borderRadius: radius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.file_upload_outlined,
                size: 18.r,
                color: ColorPalette.white,
              ),
              6.horizontalSpace,
              Text(
                Strings.uploadPrescription,
                style: FontPalette.base600(12, color: ColorPalette.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// lib/src/prescription/view/widget/prescription_guidelines_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/src/prescription/view/widget/prescription_guidelines_content.dart';

class PrescriptionGuidelinesSection extends StatelessWidget {
  const PrescriptionGuidelinesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: ColorPalette.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: ColorPalette.prescriptionUploadDashedBorder,
          width: 1.w,
        ),
      ),
      child: const PrescriptionGuidelinesContent(compact: true),
    );
  }
}

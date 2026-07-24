// lib/src/prescription/view/widget/prescription_guidelines_sheet.dart
import 'package:flutter/material.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/src/prescription/view/widget/prescription_guidelines_content.dart';
import 'package:medpik/utils/common_widgets/common_bottom_sheet.dart';

class PrescriptionGuidelinesSheet {
  PrescriptionGuidelinesSheet._();

  static Future<void> show(BuildContext context) {
    return CommonBottomSheet.show(
      context: context,
      title: Strings.prescriptionGuidelinesTitle,
      isScrollControlled: true,
      child: const SingleChildScrollView(
        child: PrescriptionGuidelinesContent(),
      ),
    );
  }
}

// lib/src/prescription/view/widget/prescription_guidelines_content.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';

class PrescriptionGuidelinesContent extends StatelessWidget {
  const PrescriptionGuidelinesContent({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final titleStyle = FontPalette.base700(
      compact ? 13 : 15,
      color: colors.primaryText,
    );
    final sectionGap = compact ? 8.h : 20.h;
    final dosTitleStyle = FontPalette.base600(
      compact ? 11 : 12,
      color: colors.secondaryText,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.prescriptionValidContainsTitle, style: titleStyle),
        (compact ? 6 : 10).verticalSpace,
        _ValidPrescriptionBullets(compact: compact),
        SizedBox(height: sectionGap),
        Text(Strings.prescriptionDosAndDonts, style: dosTitleStyle),
        (compact ? 6 : 12).verticalSpace,
        if (compact)
          const _CompactDosDontsBullets()
        else ...[
          const _GuidelineRuleRow(
            isPositive: true,
            title: Strings.prescriptionDoUploadClearImage,
            description: Strings.prescriptionDoUploadClearImageDesc,
          ),
          14.verticalSpace,
          const _GuidelineRuleRow(
            isPositive: false,
            title: Strings.prescriptionDontMedicinePicture,
          ),
          12.verticalSpace,
          const _GuidelineRuleRow(
            isPositive: false,
            title: Strings.prescriptionDontCropImage,
          ),
        ],
      ],
    );
  }
}

class _ValidPrescriptionBullets extends StatelessWidget {
  const _ValidPrescriptionBullets({required this.compact});

  final bool compact;

  static const _items = [
    Strings.prescriptionDoctorDetails,
    Strings.prescriptionDateOfPrescription,
    Strings.prescriptionPatientDetails,
    Strings.prescriptionDosageDetails,
  ];

  @override
  Widget build(BuildContext context) {
    return _BulletList(items: _items, compact: compact);
  }
}

class _CompactDosDontsBullets extends StatelessWidget {
  const _CompactDosDontsBullets();

  static const _items = [
    Strings.prescriptionDoUploadClearImage,
    Strings.prescriptionDontMedicinePicture,
    Strings.prescriptionDontCropImage,
  ];

  @override
  Widget build(BuildContext context) {
    return const _BulletList(items: _items, compact: true);
  }
}

class _BulletList extends StatelessWidget {
  const _BulletList({required this.items, required this.compact});

  final List<String> items;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textStyle = FontPalette.base400(
      compact ? 12 : 14,
      color: colors.secondaryText,
    );
    final itemGap = compact ? 2.h : 6.h;
    final bulletGap = compact ? 6.w : 8.w;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: itemGap),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('•', style: textStyle),
                  SizedBox(width: bulletGap),
                  Expanded(child: Text(item, style: textStyle)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _GuidelineRuleRow extends StatelessWidget {
  const _GuidelineRuleRow({
    required this.isPositive,
    required this.title,
    this.description,
  });

  final bool isPositive;
  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final iconBg = isPositive
        ? colors.statusSuccessBg
        : colors.statusErrorBg;
    final iconColor = isPositive
        ? colors.statusSuccessText
        : colors.statusErrorText;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28.r,
          height: 28.r,
          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
          child: Icon(
            isPositive ? Icons.check_rounded : Icons.close_rounded,
            size: 16.r,
            color: iconColor,
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: FontPalette.base700(14, color: colors.primaryText),
              ),
              if (description != null) ...[
                4.verticalSpace,
                Text(
                  description!,
                  style: FontPalette.base400(12, color: colors.secondaryText),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

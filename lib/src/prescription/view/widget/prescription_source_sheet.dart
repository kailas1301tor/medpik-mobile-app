// lib/src/prescription/view/widget/prescription_source_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medpik/res/constants/medpik_svg_assets.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/prescription/notifier/prescription_notifier.dart';
import 'package:medpik/src/prescription/view/widget/prescription_guidelines_section.dart';
import 'package:medpik/utils/common_widgets/common_bottom_sheet.dart';

class PrescriptionSourceSheet {
  PrescriptionSourceSheet._();

  static Future<void> show(BuildContext context, WidgetRef ref) {
    return CommonBottomSheet.show(
      context: context,
      title: Strings.selectSourceTitle,
      isScrollControlled: true,
      child: const _PrescriptionSourceSheetContent(),
    );
  }
}

class _PrescriptionSourceSheetContent extends ConsumerWidget {
  const _PrescriptionSourceSheetContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(prescriptionNotifierProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: _SourceOptionItem(
                iconPath: MedpikSvgAssets.sourceCamera,
                label: Strings.sourceCamera,
                onTap: () {
                  Navigator.of(context).pop();
                  notifier.pickFromCamera();
                },
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: _SourceOptionItem(
                iconPath: MedpikSvgAssets.sourceGallery,
                label: Strings.sourceGallery,
                onTap: () {
                  Navigator.of(context).pop();
                  notifier.pickFromGallery();
                },
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: _SourceOptionItem(
                iconPath: MedpikSvgAssets.sourceFiles,
                label: Strings.sourceFiles,
                onTap: () {
                  Navigator.of(context).pop();
                  notifier.pickFiles();
                },
              ),
            ),
          ],
        ),
        16.verticalSpace,
        const PrescriptionGuidelinesSection(),
      ],
    );
  }
}

class _SourceOptionItem extends StatelessWidget {
  const _SourceOptionItem({
    required this.iconPath,
    required this.label,
    required this.onTap,
  });

  final String iconPath;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Material(
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(iconPath, width: 28.r, height: 28.r),
              10.verticalSpace,
              Text(
                label,
                style: FontPalette.base500(
                  13,
                  color: colors.primaryText.withValues(alpha: 0.5),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// lib/src/prescription/view/widget/prescription_checkout_files.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart' as p;
import 'package:medpik/res/constants/medpik_svg_assets.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/prescription/view/widget/prescription_full_preview.dart';
import 'package:medpik/utils/helpers/file_picker.dart';

class PrescriptionCheckoutFiles extends StatelessWidget {
  const PrescriptionCheckoutFiles({super.key, required this.filePaths});

  final List<String> filePaths;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    if (filePaths.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          Strings.attachedPrescriptions,
          style: FontPalette.base700(15, color: colors.primaryText),
        ),
        12.verticalSpace,
        SizedBox(
          height: 88.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: filePaths.length,
            separatorBuilder: (_, _) => 12.horizontalSpace,
            itemBuilder: (context, index) {
              return _PrescriptionCheckoutThumb(filePath: filePaths[index]);
            },
          ),
        ),
        16.verticalSpace,
      ],
    );
  }
}

class _PrescriptionCheckoutThumb extends StatelessWidget {
  const _PrescriptionCheckoutThumb({required this.filePath});

  final String filePath;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isImage = isImageFilePath(filePath);
    final fileName = p.basename(filePath);
    final size = 80.r;

    return Material(
      color: colors.inputBackground,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: () => PrescriptionFullPreview.show(context, filePath),
        borderRadius: BorderRadius.circular(14.r),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: SizedBox(
            width: size,
            height: size,
            child: isImage
                ? Image.file(
                    File(filePath),
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                  )
                : Padding(
                    padding: EdgeInsets.all(8.r),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          MedpikSvgAssets.folder,
                          width: 24.r,
                          height: 24.r,
                          colorFilter: ColorFilter.mode(
                            colors.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                        4.verticalSpace,
                        Text(
                          fileName,
                          style: FontPalette.base500(
                            10,
                            color: colors.secondaryText,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

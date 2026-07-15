// lib/src/prescription/view/widget/prescription_file_tile.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart' as p;
import 'package:tsuite/res/constants/medpik_svg_assets.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/prescription/view/widget/prescription_full_preview.dart';
import 'package:tsuite/utils/common_widgets/common_delete_icon.dart';
import 'package:tsuite/utils/helpers/file_picker.dart';

class PrescriptionFileTile extends StatelessWidget {
  const PrescriptionFileTile({
    super.key,
    required this.filePath,
    required this.onRemove,
  });

  final String filePath;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isImage = isImageFilePath(filePath);
    final fileName = p.basename(filePath);

    return SizedBox(
      width: 96.w,
      height: 96.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Material(
            color: ColorPalette.prescriptionFileTileBg,
            borderRadius: BorderRadius.circular(14.r),
            child: InkWell(
              onTap: () => PrescriptionFullPreview.show(context, filePath),
              borderRadius: BorderRadius.circular(14.r),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: isImage
                    ? Image.file(
                        File(filePath),
                        width: 96.w,
                        height: 96.w,
                        fit: BoxFit.cover,
                      )
                    : Padding(
                        padding: EdgeInsets.all(10.r),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              MedpikSvgAssets.folder,
                              width: 28.r,
                              height: 28.r,
                              colorFilter: ColorFilter.mode(
                                ColorPalette.prescriptionIconTeal,
                                BlendMode.srcIn,
                              ),
                            ),
                            6.verticalSpace,
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
          Positioned(
            top: -6.h,
            right: -6.w,
            child: Semantics(
              label: Strings.removeFile,
              child: Material(
                color: ColorPalette.white,
                shape: const CircleBorder(),
                elevation: 2,
                child: InkWell(
                  onTap: onRemove,
                  customBorder: const CircleBorder(),
                  child: Padding(
                    padding: EdgeInsets.all(4.r),
                    child: CommonDeleteIcon(size: 14.r),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

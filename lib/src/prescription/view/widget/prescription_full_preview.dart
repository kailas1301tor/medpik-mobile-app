// lib/src/prescription/view/widget/prescription_full_preview.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' as p;
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/utils/common_widgets/common_app_bar.dart';
import 'package:medpik/utils/common_widgets/common_scaffold.dart';
import 'package:medpik/utils/helpers/file_picker.dart';

class PrescriptionFullPreview {
  PrescriptionFullPreview._();

  static Future<void> show(BuildContext context, String filePath) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => _PrescriptionFullPreviewScreen(filePath: filePath),
      ),
    );
  }
}

class _PrescriptionFullPreviewScreen extends StatelessWidget {
  const _PrescriptionFullPreviewScreen({required this.filePath});

  final String filePath;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isImage = isImageFilePath(filePath);
    final fileName = p.basename(filePath);

    return CommonScaffold(
      backgroundColor: ColorPalette.black,
      enableFadeIn: false,
      appBar: CommonAppBar(
        title: '',
        backgroundColor: ColorPalette.black,
        iconColor: ColorPalette.white,
        showBackButton: false,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, size: 24.r, color: ColorPalette.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isImage
          ? InteractiveViewer(
              minScale: 0.5,
              maxScale: 4,
              child: Center(
                child: Image.file(
                  File(filePath),
                  fit: BoxFit.contain,
                ),
              ),
            )
          : Center(
              child: Padding(
                padding: EdgeInsets.all(24.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.insert_drive_file_outlined,
                      size: 64.r,
                      color: ColorPalette.white,
                    ),
                    16.verticalSpace,
                    Text(
                      fileName,
                      style: FontPalette.base600(16, color: ColorPalette.white),
                      textAlign: TextAlign.center,
                    ),
                    8.verticalSpace,
                    Text(
                      Strings.previewNotAvailable,
                      style: FontPalette.base400(13, color: colors.secondaryText),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

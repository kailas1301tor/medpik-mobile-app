import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsuite/res/styles/app_theme.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/src/prescription/view/widget/prescription_upload_area.dart';
import 'package:tsuite/utils/common_widgets/dashed_border_container.dart';

void main() {
  testWidgets('PrescriptionUploadArea uses dark theme surface colors', (
    tester,
  ) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(800, 600),
        minTextAdapt: true,
        builder: (_, __) => MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: Center(
              child: SizedBox(
                width: 343,
                height: 180,
                child: PrescriptionUploadArea(onTap: _noop),
              ),
            ),
          ),
        ),
      ),
    );

    final uploadArea = tester.widget<DashedBorderContainer>(
      find.byType(DashedBorderContainer),
    );

    expect(uploadArea.backgroundColor, AppColors.dark.inputBackground);
    expect(uploadArea.borderColor, AppColors.dark.inputBorder);
    expect(uploadArea.backgroundColor, isNot(ColorPalette.prescriptionUploadAreaBg));
  });
}

void _noop() {}

// test/light_mode_card_border_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';

void main() {
  test('light mode uses the stronger neutral card border', () {
    expect(AppColors.light.cardBorder, const Color(0xFFD9DEE3));
    expect(AppColors.dark.cardBorder, const Color(0xFF2F3844));
  });

  testWidgets('CommonContainer renders cardBorder at full opacity', (
    tester,
  ) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, child) => MaterialApp(
          theme: ThemeData(
            extensions: const <ThemeExtension<dynamic>>[AppColors.light],
          ),
          home: child,
        ),
        child: const CommonContainer(child: SizedBox()),
      ),
    );

    final container = tester.widget<SmoothContainer>(
      find.byType(SmoothContainer),
    );

    expect(container.side.color, AppColors.light.cardBorder);
    expect(container.side.color.a, 1);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/app_theme.dart';
import 'package:medpik/src/profile/model/store_profile_model.dart';
import 'package:medpik/src/profile/view/widget/support_contact_content_widget.dart';

void main() {
  Future<void> pumpContent(
    WidgetTester tester,
    StoreProfileModel profile,
  ) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: SupportContactContentWidget(storeProfile: profile),
          ),
        ),
      ),
    );
  }

  testWidgets('shows phone and email actions when both are available', (
    tester,
  ) async {
    await pumpContent(
      tester,
      const StoreProfileModel(
        supportPhone: '+1234567890',
        supportEmail: 'support@medpik.com',
      ),
    );

    expect(find.text(Strings.callSupport), findsOneWidget);
    expect(find.text('+1234567890'), findsOneWidget);
    expect(find.text(Strings.emailSupport), findsOneWidget);
    expect(find.text('support@medpik.com'), findsOneWidget);
  });

  testWidgets('hides a contact action when its value is blank', (tester) async {
    await pumpContent(
      tester,
      const StoreProfileModel(supportEmail: 'support@medpik.com'),
    );

    expect(find.text(Strings.callSupport), findsNothing);
    expect(find.text(Strings.emailSupport), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/app_theme.dart';
import 'package:medpik/utils/common_widgets/common_search_bar.dart';

void main() {
  testWidgets('CommonSearchBar shows clear button only when text is present', (
    tester,
  ) async {
    final controller = TextEditingController();

    await tester.pumpWidget(_buildSearchBar(controller: controller));
    expect(find.byTooltip(Strings.clear), findsNothing);

    controller.text = 'paracetamol';
    await tester.pump();

    expect(find.byTooltip(Strings.clear), findsOneWidget);
  });

  testWidgets('CommonSearchBar clear calls onClear without duplicate onChanged', (
    tester,
  ) async {
    final controller = TextEditingController();
    var onChangedCount = 0;
    var onClearCount = 0;

    await tester.pumpWidget(
      _buildSearchBar(
        controller: controller,
        onChanged: (_) => onChangedCount++,
        onClear: () => onClearCount++,
      ),
    );

    await tester.enterText(find.byType(TextFormField), 'paracetamol');
    await tester.pump();
    final countBeforeClear = onChangedCount;

    await tester.tap(find.byTooltip(Strings.clear));
    await tester.pump();

    expect(controller.text, isEmpty);
    expect(onChangedCount, countBeforeClear);
    expect(onClearCount, 1);
  });

  testWidgets('CommonSearchBar shows trailing alongside clear button', (
    tester,
  ) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      _buildSearchBar(
        controller: controller,
        trailing: const Icon(Icons.filter_list, key: Key('search_trailing')),
      ),
    );

    expect(find.byKey(const Key('search_trailing')), findsOneWidget);
    expect(find.byTooltip(Strings.clear), findsNothing);

    controller.text = 'vitamin';
    await tester.pump();

    expect(find.byKey(const Key('search_trailing')), findsOneWidget);
    expect(find.byTooltip(Strings.clear), findsOneWidget);
  });
}

Widget _buildSearchBar({
  required TextEditingController controller,
  ValueChanged<String>? onChanged,
  VoidCallback? onClear,
  Widget? trailing,
}) {
  return ScreenUtilInit(
    designSize: const Size(390, 844),
    builder: (_, __) => MaterialApp(
      theme: AppTheme.darkTheme,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: CommonSearchBar(
            controller: controller,
            onChanged: onChanged,
            onClear: onClear,
            trailing: trailing,
          ),
        ),
      ),
    ),
  );
}

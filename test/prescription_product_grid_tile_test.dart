import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medpik/data/models/product_model.dart';
import 'package:medpik/res/styles/app_theme.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/src/prescription/view/widget/prescription_product_grid_tile.dart';

void main() {
  testWidgets('PrescriptionProductGridTile uses dark theme card colors', (
    tester,
  ) async {
    const product = ProductModel(
      id: 1,
      name: 'Digene Mint',
      category: 'Digestive Care',
      price: 10,
      imageUrl: '',
      requiresPrescription: false,
      packSize: '200ML',
    );

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(800, 600),
        minTextAdapt: true,
        builder: (_, __) => ProviderScope(
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: const Scaffold(
              body: Center(
                child: SizedBox(
                  width: 180,
                  height: 180,
                  child: PrescriptionProductGridTile(product: product),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final decoratedBox = tester.widget<DecoratedBox>(
      find.byType(DecoratedBox).first,
    );
    final decoration = decoratedBox.decoration as BoxDecoration;

    expect(decoration.color, AppColors.dark.cardBackground);
    expect(decoration.border?.top.color, AppColors.dark.cardBorder);
    expect(decoration.color, isNot(ColorPalette.productCardBg));
  });
}

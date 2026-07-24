import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:medpik/res/styles/color_palette.dart';

class AppTheme {
  AppTheme._(); // ✅ Prevent instantiation — pure static class

  // ✅ Extracted once — shared between light and dark
  static const _pageTransitions = PageTransitionsTheme(
    builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(
        allowEnterRouteSnapshotting: false,
      ),
      TargetPlatform.iOS:
          CupertinoPageTransitionsBuilder(), // ✅ native iOS feel
    },
  );

  // ✅ Extracted once — reused in both themes
  static ColorScheme _buildColorScheme({
    required Brightness brightness,
    required Color surface,
    required Color surfaceVariant,
  }) {
    return ColorScheme.fromSeed(
      seedColor: ColorPalette.primaryColor,
      brightness: brightness,
    ).copyWith(
      primary: ColorPalette.primaryColor,
      secondary: ColorPalette.secondaryColor,
      surface: surface,
      surfaceContainerHighest: surfaceVariant,
      surfaceContainerHigh: surfaceVariant,
      surfaceContainer: surfaceVariant,
      surfaceContainerLow: surfaceVariant,
      surfaceContainerLowest: surfaceVariant,
      surfaceBright: surfaceVariant,
      surfaceDim: surfaceVariant,
    );
  }

  static ThemeData get lightTheme {
    final colorScheme = _buildColorScheme(
      brightness: Brightness.light,
      surface: ColorPalette.white,
      surfaceVariant: ColorPalette.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: ColorPalette.white,
      extensions: const [AppColors.light],
      pageTransitionsTheme: _pageTransitions, // ✅ shared
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: ColorPalette.white,
        surfaceTintColor: Colors.transparent,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ColorPalette.white,
        titleTextStyle: null,
        // ✅ Removed systemOverlayStyle — CommonAppBar handles this per screen
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        scrolledUnderElevation: 0, // ✅ no M3 elevation tint
        surfaceTintColor: Colors.transparent, // ✅ no M3 surface tint
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.black,
      ),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = _buildColorScheme(
      brightness: Brightness.dark,
      surface: AppColors.dark.surface,
      surfaceVariant: AppColors.dark.cardBackground,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.dark.background,
      extensions: const [AppColors.dark],
      pageTransitionsTheme: _pageTransitions, // ✅ shared
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.dark.surface,
        surfaceTintColor: Colors.transparent,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.dark.background,
        titleTextStyle: null,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.white,
      ),
    );
  }

  static Color get barrierColor => Colors.black.withValues(alpha: .50);

  // ✅ Uses actual primaryColor value instead of hardcoded hex
  static MaterialColor get materialPrimary =>
      MaterialColor(ColorPalette.primaryColor.toARGB32(), const <int, Color>{
        50: ColorPalette.primaryColor,
        100: ColorPalette.primaryColor,
        200: ColorPalette.primaryColor,
        300: ColorPalette.primaryColor,
        400: ColorPalette.primaryColor,
        500: ColorPalette.primaryColor,
        600: ColorPalette.primaryColor,
        700: ColorPalette.primaryColor,
        800: ColorPalette.primaryColor,
        900: ColorPalette.primaryColor,
      });
}

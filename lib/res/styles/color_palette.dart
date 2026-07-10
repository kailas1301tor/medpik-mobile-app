import 'package:flutter/material.dart';

class ColorPalette {
  // Brand colors — Custom Teal primary
  static const primaryColor = Color(0xFF007F7F);
  static const primaryColorDark = Color(0xFF005959);
  static const accentIndigo = Color(0xFF007F7F);
  static const secondaryColor = Color(0xFF14B8A6);
  static const formValidationErrorColor = Color(0xFFFF453A);
  static const successColor = Color(0xFF34C759);
  static const warningColor = Color(0xFFFF9F0A);

  static const primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primaryColor, primaryColorDark],
  );

  // Basic colors
  static const transparent = Colors.transparent;
  static const black = Colors.black;
  static const white = Colors.white;
  static const grey = Colors.grey;

  // Custom colors
  static const f191B1E = Color(0xFF191B1E);
  static const fF1F1F1 = Color(0xFFF1F1F1);
  static const f6D6D6D = Color(0xFF6D6D6D);
  static const fE7E7E7 = Color(0xFFE7E7E7);
  static const fD1D1D1 = Color(0xFFD1D1D1);
  static const f4F4F4F = Color(0xFF4F4F4F);
  static const fF6F6F6 = Color(0xFFF6F6F6);
  static const fF4F4F4 = Color(0xFFF4F4F4);
  static const fD9D9D9 = Color(0xFFD9D9D9);
  static const f888888 = Color(0xFF888888);
  static const fF0F0F0 = Color(0xFFF0F0F0);
  static const fEAEAEA = Color(0xFFEAEAEA);
  static const fFBFBFB = Color(0xFFFBFBFB);
  static const f444444 = Color(0xFF444444);
  static const f10000 = Color(0xFFF10000);
  static const f787878 = Color(0xFF787878);
  static const f3D3D3D = Color(0xFF3D3D3D);
  static const f9A1D20 = Color(0xFF9A1D20);
  static const f753401 = Color(0xFF753401);
  static const f656565 = Color(0xFF656565);
  static const f009E35 = Color(0xFF009E35);
  static const fF19121 = Color(0xFFF19121);
  static const f585858 = Color(0xFF585858);
  static const fFF6161 = Color(0xFFFF6161);
  static const f00AF63 = Color(0xFF00AF63);
  static const f674011 = Color(0xFF674011);
  static const f7C6225 = Color(0xFF7C6225);
  static const fE53B40 = Color(0xFFE53B40);
  static const red = Colors.red;
  static const f707070 = Color(0xFF707070);
  static const f0E0F0C = Color(0xFF0E0F0C);
  static const f808080 = Color(0xFF808080);
  static const f5A5A5A = Color(0xFF5A5A5A);
  static const f13AC00 = Color(0xFF13AC00);
  static const fFF9500 = Color(0xFFFF9500);
  static const f80011F = Color(0xFF80011F);
  static const f111113 = Color(0xFF111113);
  static const f292929 = Color(0xFF292929);
  static const fC88C00 = Color(0xFFC88C00);
  static const fA8A8A8 = Color(0xFFA8A8A8);
  static const f050E13 = Color(0xFF050E13);
  static const f544016 = Color(0xFF544016);
  static const fFFEACC = Color(0xFFFFEACC);
  static const f844800 = Color(0xFF844800);
  static const fCA8E00 = Color(0xFFCA8E00);
  static const fF10000 = Color(0xFFF10000);
  static const f22A06D = Color(0xFF22A06D);
  static const f2DBB7E = Color(0xFF2DBB7E);
  static const f787879 = Color(0xFF787879);
  static const fBFBFBF = Color(0xFFBFBFBF);

  // Home screen design tokens
  static const prescriptionBannerBg = Color(0xFFE8F5F3);
  static const offerCardBg = Color(0xFFFFF8E7);
  static const offerBadgeBg = Color(0xFFFFE082);
  static const offerBadgeText = Color(0xFF6B4F00);

  // Hero brand gradient stops
  static const heroTealDark = Color(0xFF032B36);
  static const heroTealMid = Color(0xFF064A5B);
  static const heroTealLight = Color(0xFF0A6C7D);

  // Prescription card — healthcare palette
  static const prescriptionGradientStart = Color(0xFFF2FCFC);
  static const prescriptionGradientMid = Color(0xFFDFF7F5);
  static const prescriptionGradientEnd = Color(0xFFC8F2EE);
  static const prescriptionUploadBtn = Color(0xFF006D77);
  static const prescriptionUploadBtnPressed = Color(0xFF005A63);
  static const prescriptionIconTeal = Color(0xFF00897B);
  static const prescriptionUploadDashedBorder = Color(0xFF7AB8B8);
  static const prescriptionUploadAreaBg = Color(0xFFF8FCFC);
  static const prescriptionFileTileBg = Color(0xFFF5F7F7);
  static const prescriptionGuidelineIconBg = Color(0xFFEEF4FF);
  static const prescriptionDoIconBg = Color(0xFFE8F8F0);
  static const prescriptionDontIconBg = Color(0xFFFDECEC);
  static const prescriptionDiscountBadgeBg = Color(0xFFFFD54F);
  static const prescriptionDiscountBadgeText = Color(0xFF5A4300);
  static const prescriptionGlassBg = Color(
    0xBFFFFFFF,
  ); // rgba(255,255,255,0.75)
  static const prescriptionGlassBorder = Color(
    0x14006D77,
  ); // rgba(0,109,119,0.08)

  // Liquid Glass surface tokens
  static const glassSurface = Color.fromARGB(194, 255, 255, 255); // ~0.76 white
  static const glassBorderTop = Color(0x99FFFFFF); // luminous top edge
  static const glassBorderBottom = Color(0x1FFFFFFF); // faint bottom edge
  static const glassInnerHighlight = Color(0x80FFFFFF);
  static const glassHighlightTeal = Color(0x3300B3A6); // cool radial glow
  static const glassHighlightWarm = Color(0x40FFFFFF); // warm radial glow
  static const glassChipFill = Color(0x59FFFFFF); // ~0.35 white frosted pill

  // Product glass card tokens
  static const productGlassSurface = Color(
    0xB8FFFFFF,
  ); // rgba(255,255,255,0.72)
  static const productGlassBorder = Color(0x8CFFFFFF); // rgba(255,255,255,0.55)
  static const productGlassReflection = Color(0xFFE8FAF8);
  static const productAccentTeal = Color(0xFF0E8B8F);
  static const productDiscountBadge = Color(0xE6006D77); // rgba(0,109,119,0.9)
  static const productWishlistGlass = Color(
    0x73FFFFFF,
  ); // rgba(255,255,255,0.45)
  static const productCtaGlass = Color(0x8CFFFFFF); // rgba(255,255,255,0.55)

  // Clean product card tokens
  static const productCardBg = white;
  static const productCardBorder = Color(0xFFEDEFF1);
  static const productImageBg = Color(0xFFF4F7F8);
  static const productSavingsGreen = Color(0xFF22A06D);

  static List<BoxShadow> get productCardShadow => [
    BoxShadow(
      color: ColorPalette.black.withValues(alpha: 0.06),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> productGlassCardShadow({double depth = 1.0}) => [
    BoxShadow(
      color: ColorPalette.black.withValues(alpha: 0.05 * depth),
      blurRadius: 24,
      offset: Offset(0, 10 * depth),
    ),
    BoxShadow(
      color: ColorPalette.productAccentTeal.withValues(alpha: 0.03 * depth),
      blurRadius: 16,
      offset: Offset(0, 6 * depth),
    ),
  ];

  static List<BoxShadow> get glassCardShadow => [
    BoxShadow(
      color: ColorPalette.black.withValues(alpha: 0.10),
      blurRadius: 40,
      offset: const Offset(0, 18),
    ),
    BoxShadow(
      color: prescriptionUploadBtn.withValues(alpha: 0.08),
      blurRadius: 24,
      offset: const Offset(0, 6),
    ),
  ];

  static const prescriptionCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      prescriptionGradientStart,
      prescriptionGradientMid,
      prescriptionGradientEnd,
    ],
  );

  static List<BoxShadow> get prescriptionCardShadow => [
    BoxShadow(
      color: ColorPalette.black.withValues(alpha: 0.08),
      blurRadius: 40,
      offset: const Offset(0, 16),
    ),
  ];

  // Offer banner promotional gradients (Swiggy/Zomato style)
  static const offerBlueCyan = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF1D4ED8), Color(0xFF06B6D4)],
  );

  static const offerOrangeAmber = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFEA580C), Color(0xFFFBBF24)],
  );

  static const offerPurplePink = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
  );

  static const offerRedOrange = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFDC2626), Color(0xFFF97316)],
  );

  static const offerGreenLime = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF16A34A), Color(0xFFA3E635)],
  );
}

/// ThemeExtension to support dynamic color switching between Light and Dark mode
/// for custom branded colors that fall outside standard Material semantic colors.
class AppColors extends ThemeExtension<AppColors> {
  final Color primaryText;
  final Color secondaryText;
  final Color background;
  final Color authBackground;
  final Color surface;
  final Color errorText;
  final Color inputBorder;
  final Color inputBackground;
  final Color primary;
  final Color primaryDark;
  final Color secondary;
  final Color accent;

  const AppColors({
    required this.primaryText,
    required this.secondaryText,
    required this.background,
    required this.authBackground,
    required this.surface,
    required this.errorText,
    required this.inputBorder,
    required this.inputBackground,
    required this.primary,
    required this.primaryDark,
    required this.secondary,
    required this.accent,
  });

  LinearGradient get primaryGradient => LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primary, primaryDark],
  );

  @override
  AppColors copyWith({
    Color? primaryText,
    Color? secondaryText,
    Color? background,
    Color? authBackground,
    Color? surface,
    Color? errorText,
    Color? inputBorder,
    Color? inputBackground,
    Color? primary,
    Color? primaryDark,
    Color? secondary,
    Color? accent,
  }) {
    return AppColors(
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      background: background ?? this.background,
      authBackground: authBackground ?? this.authBackground,
      surface: surface ?? this.surface,
      errorText: errorText ?? this.errorText,
      inputBorder: inputBorder ?? this.inputBorder,
      inputBackground: inputBackground ?? this.inputBackground,
      primary: primary ?? this.primary,
      primaryDark: primaryDark ?? this.primaryDark,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      background: Color.lerp(background, other.background, t)!,
      authBackground: Color.lerp(authBackground, other.authBackground, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      errorText: Color.lerp(errorText, other.errorText, t)!,
      inputBorder: Color.lerp(inputBorder, other.inputBorder, t)!,
      inputBackground: Color.lerp(inputBackground, other.inputBackground, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
    );
  }

  /// Preset for Light Mode — e-commerce retail aesthetics
  static const AppColors light = AppColors(
    primaryText: Color(0xFF1D1D1F),
    secondaryText: Color(0xFF86868B),
    background: ColorPalette.white,
    authBackground: ColorPalette.white,
    surface: ColorPalette.white,
    errorText: ColorPalette.formValidationErrorColor,
    inputBorder: Color(0xFFD2D2D7),
    inputBackground: Color(0xFFF5F5F7),
    primary: ColorPalette.primaryColor,
    primaryDark: ColorPalette.primaryColorDark,
    secondary: ColorPalette.secondaryColor,
    accent: ColorPalette.primaryColor,
  );

  /// Preset for Dark Mode — Premium Slate & Indigo
  static const AppColors dark = AppColors(
    primaryText: Color(0xFFF5F5F7),
    secondaryText: Color(0xFF86868B),
    background: Color(0xFF0A0B0F),
    authBackground: Color(0xFF12131A),
    surface: Color(0xFF16171D),
    errorText: Color(0xFFFF6961),
    inputBorder: Color(0xFF2C2C2E),
    inputBackground: Color(0xFF1C1C1E),
    primary: ColorPalette.primaryColor,
    primaryDark: ColorPalette.primaryColorDark,
    secondary: ColorPalette.secondaryColor,
    accent: ColorPalette.primaryColor,
  );
}

extension AppContext on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}

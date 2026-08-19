import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';

class FontPalette {
  static const String fontFamily = 'onest';

  //! 🔹 Base styles by weight
  static TextStyle base400(
    double fontSize, {
    Color color = ColorPalette.black,
    Gradient? gradient,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize.sp,
      fontWeight: FontWeight.w400,
      color: gradient == null ? color : null,
      foreground: gradient != null
          ? (Paint()
              ..shader = gradient.createShader(Rect.fromLTWH(0, 0, 200, 70)))
          : null,
    );
  }

  static TextStyle base500(
    double fontSize, {
    Color color = ColorPalette.black,
    Gradient? gradient,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize.sp,
      fontWeight: FontWeight.w500,
      color: gradient == null ? color : null,
      foreground: gradient != null
          ? (Paint()
              ..shader = gradient.createShader(Rect.fromLTWH(0, 0, 200, 70)))
          : null,
      decoration: decoration,
    );
  }

  static TextStyle base600(
    double fontSize, {
    Color color = ColorPalette.black,
    Gradient? gradient,
    double? height,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize.sp,
      fontWeight: FontWeight.w600,
      color: gradient == null ? color : null,
      foreground: gradient != null
          ? (Paint()
              ..shader = gradient.createShader(Rect.fromLTWH(0, 0, 200, 70)))
          : null,
      height: height?.sp,
    );
  }

  static TextStyle base700(
    double fontSize, {
    Color color = ColorPalette.black,
    double? height,
    Gradient? gradient,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize.sp,
      fontWeight: FontWeight.w700,
      color: gradient == null ? color : null,
      foreground: gradient != null
          ? (Paint()
              ..shader = gradient.createShader(Rect.fromLTWH(0, 0, 200, 70)))
          : null,

      height: height,
    );
  }

  //!🔹 Common variants (examples)
  //*-------10-------------------------------------
  static final TextStyle fBlack_10_400 = base400(10, color: ColorPalette.black);
  static final TextStyle fBlack_10_500 = base500(10, color: ColorPalette.black);
  static final TextStyle fBlack_10_600 = base600(10, color: ColorPalette.black);
  static final TextStyle fWhite_10_500 = base500(10, color: ColorPalette.white);
  static final TextStyle fWhite_10_600 = base600(10, color: ColorPalette.white);
  static final TextStyle fWhite_10_400 = base400(10, color: ColorPalette.white);
  static final TextStyle f444444_10_400 = base400(
    10,
    color: ColorPalette.f444444,
  );

  static final TextStyle fF10000_10_600 = base600(
    10,
    color: ColorPalette.f10000,
  );
  static final TextStyle f009E35_10_600 = base600(
    10,
    color: ColorPalette.primaryColor,
  );

  //*-------11-------------------------------------
  static final TextStyle fBlack_11_700 = base700(11, color: ColorPalette.black);
  static final TextStyle f787878_10_400 = base400(
    10,
    color: ColorPalette.f787878,
  );

  //*-------12-------------------------------------

  static final TextStyle f3D3D3D_12_400 = base400(
    12,
    color: ColorPalette.f3D3D3D,
  );
  static final TextStyle ff10000_12_400 = base400(
    12,
    color: ColorPalette.f10000,
  );
  static final TextStyle f9A1D20_12_600 = base600(
    12,
    color: ColorPalette.f9A1D20,
  );
  static final TextStyle ff753401_12_600 = base600(
    12,
    color: ColorPalette.f753401,
  );

  static final TextStyle f444444_12_400 = base400(
    12,
    color: ColorPalette.f444444,
  );

  static final TextStyle f525252_12_400 = base400(12, color: Color(0XFF525252));

  static final TextStyle fWhite_12_400 = base400(12, color: ColorPalette.white);

  static final TextStyle fFED841FFE9BB_12_400 = base400(
    12,
    gradient: LinearGradient(
      colors: [Color(0XFFFED841), Color(0XFFFFE9BB)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static final TextStyle f656565_12_500 = base500(
    12,
    color: ColorPalette.f656565,
  );

  static final TextStyle f009E35_12_600 = base600(
    12,
    color: ColorPalette.f009E35,
  );

  static final TextStyle fF19121_12_500 = base500(
    12,
    color: ColorPalette.fF19121,
  );

  static final TextStyle f585858_12_400 = base400(
    12,
    color: ColorPalette.f585858,
  );

  static final TextStyle f585858_12_500 = base500(
    12,
    color: ColorPalette.f585858,
  );

  static final TextStyle f6D6D6D_12_400 = base400(
    12,
    color: const Color(0xFF6D6D6D),
  );

  static final TextStyle fFF6161_12_400 = base400(
    12,
    color: ColorPalette.fFF6161,
  );

  static final TextStyle f00AF63_12_400 = base400(
    12,
    color: ColorPalette.f00AF63,
  );

  //*-------13-------------------------------------
  static final TextStyle f3D3D3D_13_400 = base400(
    13,
    color: ColorPalette.f3D3D3D,
  );
  static final TextStyle fBlack_12_400 = base400(12, color: ColorPalette.black);
  static final TextStyle f674011_12_400 = base400(
    12,
    color: ColorPalette.f674011,
  );
  static final TextStyle fF10000_12_400 = base400(
    12,
    color: ColorPalette.f10000,
  );

  static final TextStyle fWhite_13_600 = base600(13, color: ColorPalette.white);

  static final TextStyle fBlack_13_500 = base500(13, color: ColorPalette.black);

  static final TextStyle f6B6B6B_11_400 = base400(11, color: Color(0XFF6B6B6B));
  static final TextStyle fBlack_12_500 = base500(12, color: ColorPalette.black);
  static final TextStyle fBlack_12_600 = base600(12, color: ColorPalette.black);
  static final TextStyle fBlack_12_700 = base700(12, color: ColorPalette.black);
  static final TextStyle fWhite_12_500 = base500(12, color: ColorPalette.white);
  static final TextStyle fWhite_12_600 = base600(12, color: ColorPalette.white);
  static TextStyle fWhiteUnderline_12_600 =
      base600(12, color: ColorPalette.white).copyWith(
        decoration: TextDecoration.underline,
        decorationColor: ColorPalette.white,
        decorationThickness: 1.5,
      );
  static final TextStyle f7C6225_12_400 = base400(
    12,
    color: ColorPalette.f7C6225,
  );
  static final TextStyle ff10000_12_600 = base600(
    12,
    color: ColorPalette.f10000,
  );

  static final TextStyle f674011_12_700 = base700(
    12,
    color: ColorPalette.f674011,
  );

  static final TextStyle f11672E_12_700 = base700(
    12,
    color: const Color(0xFF11672E),
  );

  //*-------13-------------------------------------
  static final TextStyle fRed_12_400 = base400(12, color: ColorPalette.fE53B40);
  static final TextStyle fRed_12_600 = base600(12, color: ColorPalette.fE53B40);
  static final TextStyle fRed_13_400 = base400(13, color: ColorPalette.fE53B40);
  static final TextStyle f3D3D3D_13_500 = base500(
    13,
    color: ColorPalette.f3D3D3D,
  );

  static final TextStyle f9A1D20_13_600 = base600(
    13,
    color: ColorPalette.f9A1D20,
  );

  static final TextStyle fF10000_13_500 = base500(
    13,
    color: ColorPalette.fF10000,
  );
  static final TextStyle f444444_13_400 = base400(
    13,
    color: ColorPalette.f444444,
  );
  // *-------14-------------------------------------
  static final TextStyle fBlack_14_400 = base400(14, color: ColorPalette.black);
  static final TextStyle fWhite_14_400 = base400(14, color: ColorPalette.white);
  static final TextStyle f111111399_14_400 = base400(
    14,
    color: ColorPalette.black.withValues(alpha: 0.6),
  );
  static final TextStyle f6D6D6D_14_400 = base400(
    14,
    color: const Color(0xFF6D6D6D),
  );
  static final TextStyle f5D5D5D_14_400 = base400(14, color: Color(0xFF5D5D5D));
  static final TextStyle f767676_14_500 = base500(14, color: Color(0xFF767676));
  static final TextStyle f444444_14_400 = base400(
    14,
    color: ColorPalette.f444444,
  );
  static final TextStyle fRed_14_400 = base400(14, color: ColorPalette.red);
  static final TextStyle f444444_14_500 = base500(
    14,
    color: ColorPalette.f444444,
  );

  static final TextStyle f707070_14_500 = base500(
    14,
    color: ColorPalette.f707070,
  );

  static final TextStyle f0E0F0C_14_500 = base500(
    14,
    color: ColorPalette.f0E0F0C,
  );
  static final TextStyle f3D3D3D_14_400 = base400(
    14,
    color: ColorPalette.f3D3D3D,
  );
  static final TextStyle f674011_14_600 = base600(
    14,
    color: ColorPalette.f674011,
  );
  static final TextStyle f009E35_14_600 = base600(
    14,
    color: ColorPalette.f009E35,
  );
  static final TextStyle f9A1D20_14_600 = base600(
    14,
    color: ColorPalette.f9A1D20,
  );
  static final TextStyle f808080_14_500 = base500(
    14,
    color: ColorPalette.f808080,
  );
  static final TextStyle f5A5A5A_14_500 = base500(
    14,
    color: ColorPalette.f5A5A5A,
  );
  static final TextStyle fBlack_14_700 = base700(14, color: ColorPalette.black);
  static final TextStyle fWhite_14_600 = base600(14, color: ColorPalette.white);

  static final TextStyle f13AC00_14_500 = base500(
    14,
    color: ColorPalette.f13AC00,
  );

  static final TextStyle ff10000_14_500 = base500(
    14,
    color: ColorPalette.f10000,
  );
  static final TextStyle fFF9500_14_500 = base500(
    14,
    color: ColorPalette.fFF9500,
  );
  static final TextStyle fBlack_14_500 = base500(14, color: ColorPalette.black);
  static final TextStyle fWhite_14_500 = base500(14, color: ColorPalette.white);
  static final TextStyle f80011F_14_600 = base600(
    14,
    color: ColorPalette.f80011F,
  );

  static final TextStyle f11111399_14_400 = base400(
    14,
    color: ColorPalette.f111113,
  );

  static final TextStyle f191B1E_14_500 = base500(
    14,
    color: ColorPalette.f191B1E,
  );

  static final TextStyle f9A1D20_14_500 = base500(
    14,
    color: ColorPalette.f9A1D20,
    decoration: TextDecoration.underline,
  );

  // *-------13-------------------------------------
  static final TextStyle fBlack_13_400 = base400(13, color: ColorPalette.black);
  static final TextStyle fBlack_13_600 = base600(13, color: ColorPalette.black);
  static final TextStyle f80011F_13_600 = base500(
    13,
    color: ColorPalette.f80011F,
  );

  static final TextStyle f292929_14_500 = base500(
    14,
    color: ColorPalette.f292929,
  );

  //*-------15-------------------------------------
  static final TextStyle fBlack_15_400 = base400(15, color: ColorPalette.black);
  static final TextStyle fBlack_15_500 = base500(15, color: ColorPalette.black);
  static final TextStyle fBlack_15_700 = base700(15, color: ColorPalette.black);
  static final TextStyle fWhite_15_500 = base500(15, color: ColorPalette.white);
  static final TextStyle f3D3D3D_15_400 = base400(
    15,
    color: ColorPalette.f3D3D3D,
  );
  static final TextStyle f3D3D3D_15_500 = base500(
    15,
    color: ColorPalette.f3D3D3D,
  );

  static final TextStyle fPrimary_15_500 = base500(
    15,
    color: ColorPalette.fC88C00,
  );

  static final TextStyle f444444_12_500 = base500(
    12,
    color: ColorPalette.f444444,
  );
  static final TextStyle f9A1D20_15_600 = base600(
    15,
    color: ColorPalette.f9A1D20,
  );

  static final TextStyle f6D6D6D_15_400 = base400(
    15,
    color: ColorPalette.f6D6D6D,
  );

  static final TextStyle f674011_15_500 = base500(
    15,
    color: ColorPalette.f674011,
  );
  //*-------16-------------------------------------
  static final TextStyle f444444_16_500 = base500(
    16,
    color: ColorPalette.f444444,
  );

  static final TextStyle f292929_16_500 = base500(
    16,
    color: ColorPalette.f292929,
  );
  static final TextStyle f191B1E_16_500 = base500(
    16,
    color: ColorPalette.f191B1E,
  );
  static final TextStyle fWhite_16_600 = base600(16, color: ColorPalette.white);
  static final TextStyle fGrey_16_600 = base600(16, color: ColorPalette.grey);
  static final TextStyle fWhite_16_500 = base500(16, color: ColorPalette.white);
  static final TextStyle fBlack_16_500 = base500(16, color: ColorPalette.black);
  static final TextStyle fBlack_16_600 = base600(16, color: ColorPalette.black);
  static final TextStyle fA8A8A8_16_600 = base600(
    16,
    color: ColorPalette.fA8A8A8,
  );

  static final TextStyle f674011_16_600 = base600(
    16,
    color: ColorPalette.f674011,
  );
  static final TextStyle f050E13_16_600 = base600(
    16,
    color: ColorPalette.f050E13,
  );

  static final TextStyle f009E35_16_600 = base600(
    16,
    color: ColorPalette.f009E35,
  );

  static final TextStyle fF10000_16_600 = base600(
    16,
    color: ColorPalette.fF10000,
  );
  static final TextStyle fBlack_16_700 = base700(16, color: ColorPalette.black);
  //*-------18-------------------------------------
  static final TextStyle fE7E7E7_18_600 = base600(
    18,
    color: ColorPalette.fE7E7E7,
  );

  static final TextStyle fBlack_18_600 = base600(18, color: ColorPalette.black);
  //*-------20-------------------------------------
  static final TextStyle fBlack_20_700 = base700(20, color: ColorPalette.black);

  static final TextStyle fE53B40_16_600 = base600(
    16,
    color: ColorPalette.fE53B40,
  );
  static final TextStyle fBlack_14_600 = base600(14, color: ColorPalette.black);
  static final TextStyle fBlack_14_600_1 = base600(
    14,
    color: ColorPalette.black,
    height: 1,
  );

  static final TextStyle fBlack_16_400 = base400(16, color: ColorPalette.black);

  //*-------18-------------------------------------
  static final TextStyle fBlack_18_500 = base500(15, color: ColorPalette.black);

  //*-------20-------------------------------------
  static final TextStyle fBlack_20_500 = base500(
    20,
    color: ColorPalette.f444444,
  );
  static final TextStyle ff544016_16_600 = base600(
    16,
    color: ColorPalette.f544016,
  );

  static final TextStyle fBlack_24_600 = base600(24, color: ColorPalette.black);

  static final TextStyle fWhite_20_500 = base500(20, color: ColorPalette.white);

  //*------- 24-------------------------------------
  static final TextStyle fBlack_24_700 = base700(24, color: ColorPalette.black);

  //*--------30-------------------------------------
  static final TextStyle fBlack_30_600 = base600(30, color: ColorPalette.black);

  //*-------31-------------------------------------
  static final TextStyle fWhiteGradient_31_700 = base700(
    31,
    gradient: LinearGradient(
      colors: [ColorPalette.fFFEACC, ColorPalette.white],
    ),
  );
  //*-------32-------------------------------------
  static final TextStyle fBlack_32_400 = base400(32, color: ColorPalette.black);
  static final TextStyle fBlack_32_700 = base700(32, color: ColorPalette.black);
  static final TextStyle fWhite_32_700 = base700(32, color: ColorPalette.white);

  //*-------34------------------------------------
  static final TextStyle fBlack_34_600 = base600(34, color: ColorPalette.black);

  //*-------64------------------------------------

  static final TextStyle fBlack_32_700_1h = base700(
    32,
    color: ColorPalette.black,
    height: 1.2,
  );

  //*-------64-------------------------------------
  static final TextStyle fBlack_64_500 = base500(64, color: ColorPalette.black);
  // *-------26-------------------------------------
  static final TextStyle fBlack_26_600 = base600(26, color: ColorPalette.black);

  static final TextStyle fBlack_26_700 = base700(26, color: ColorPalette.black);

  // *-------28-------------------------------------
  static final TextStyle fBlack_28_700 = base700(28, color: ColorPalette.black);

  // *-------40-------------------------------------
  static final TextStyle fWhite_40_600 = base600(40, color: ColorPalette.white);
  static final TextStyle fGradient_40_600 = base600(
    40,
    gradient: LinearGradient(
      colors: [ColorPalette.f844800, ColorPalette.fCA8E00],
    ),
  );

  // *-------64-------------------------------------
  static final TextStyle fBlack_64_600 = base600(64, color: ColorPalette.black);
}

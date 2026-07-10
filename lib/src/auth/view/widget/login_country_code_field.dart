// lib/src/auth/view/widget/login_country_code_field.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';

class LoginCountryCodeField extends StatelessWidget {
  const LoginCountryCodeField({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SmoothContainer(
      height: height,
      smoothness: 1,
      color: colors.surface,
      borderRadius: BorderRadius.circular(100.r),
      side: BorderSide(width: 1, color: colors.inputBorder),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(Strings.countryFlagIndia, style: FontPalette.base400(16)),
            6.horizontalSpace,
            Text(
              Strings.countryCodeIndia,
              style: FontPalette.base500(14, color: colors.primaryText),
            ),
          ],
        ),
      ),
    );
  }
}

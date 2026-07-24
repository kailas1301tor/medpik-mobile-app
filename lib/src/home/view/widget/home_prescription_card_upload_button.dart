// lib/src/home/view/widget/home_prescription_card_upload_button.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medpik/res/constants/medpik_svg_assets.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';

class HomePrescriptionCardUploadButton extends StatelessWidget {
  const HomePrescriptionCardUploadButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = BorderRadius.circular(100.r);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: ColorPalette.black.withValues(alpha: isDark ? 0.24 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: radius,
              color: isDark
                  ? colors.inputBackground
                  : ColorPalette.white.withValues(alpha: 0.88),
              gradient: isDark
                  ? null
                  : LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        ColorPalette.white.withValues(alpha: 0.95),
                        ColorPalette.white.withValues(alpha: 0.72),
                      ],
                    ),
              border: Border.all(
                color: isDark
                    ? colors.cardBorder
                    : ColorPalette.white.withValues(alpha: 0.9),
                width: 1,
              ),
            ),
            child: Material(
              color: ColorPalette.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: radius,
                splashColor: ColorPalette.prescriptionUploadBtn.withValues(
                  alpha: 0.08,
                ),
                highlightColor: ColorPalette.prescriptionIconTeal.withValues(
                  alpha: 0.06,
                ),
                child: Stack(
                  children: [
                    if (!isDark)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 14.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(19.r),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                ColorPalette.white,
                                ColorPalette.white.withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: SizedBox(
                        height: 40.h,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              MedpikSvgAssets.arrowCircleUp,
                              width: 20.r,
                              height: 20.r,
                            ),
                            6.horizontalSpace,
                            Text(
                              Strings.uploadNow,
                              style: FontPalette.base600(
                                12,
                                color: isDark
                                    ? colors.primaryText
                                    : ColorPalette.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

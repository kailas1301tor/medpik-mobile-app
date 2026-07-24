// lib/src/home/view/widget/home_prescription_card_surface.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:medpik/res/constants/assets.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/home/view/widget/home_prescription_card_chip.dart';
import 'package:medpik/src/home/view/widget/home_prescription_card_upload_button.dart';

class HomePrescriptionCardSurface extends StatelessWidget {
  const HomePrescriptionCardSurface({
    super.key,
    required this.radius,
    required this.isDark,
    required this.glassSurface,
    required this.glassBorder,
    this.onUploadTap,
  });

  final BorderRadius radius;
  final bool isDark;
  final Color glassSurface;
  final Color glassBorder;
  final VoidCallback? onUploadTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isDark ? glassSurface : ColorPalette.white,
        borderRadius: radius,
        gradient: isDark
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors.primary.withValues(alpha: 0.08),
                  colors.cardBackground.withValues(alpha: 0.0),
                ],
              )
            : ColorPalette.prescriptionCardGradient,
        border: Border.all(color: glassBorder, width: isDark ? 1 : 1.2),
      ),
      child: Stack(
        children: [
          if (isDark) ...[
            Positioned(
              top: -40.r,
              left: -30.r,
              child: HomePrescriptionCardRadialGlow(
                size: 150.r,
                color: ColorPalette.glassHighlightWarm,
              ),
            ),
            Positioned(
              bottom: -50.r,
              right: -20.r,
              child: HomePrescriptionCardRadialGlow(
                size: 170.r,
                color: ColorPalette.glassHighlightTeal,
              ),
            ),
          ],
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: radius,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: isDark
                      ? [
                          colors.primary.withValues(alpha: 0.06),
                          colors.cardBackground.withValues(alpha: 0.0),
                        ]
                      : [
                          ColorPalette.white.withValues(alpha: 0.72),
                          ColorPalette.white.withValues(alpha: 0.0),
                        ],
                ),
              ),
            ),
          ),
          Positioned(
            right: -8.w,
            bottom: 0.h,
            child: IgnorePointer(
              child: Lottie.asset(
                Assets.lottieFoodCourier,
                width: 140.w,
                height: 120.h,
                fit: BoxFit.contain,
                repeat: true,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Strings.uploadPrescription,
                  style: FontPalette.base700(18, color: colors.primaryText),
                ),
                3.verticalSpace,
                Text(
                  Strings.uploadPrescriptionSubtitle,
                  style: FontPalette.base400(12, color: colors.secondaryText),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                8.verticalSpace,
                Wrap(
                  spacing: 10.w,
                  runSpacing: 8.h,
                  children: const [
                    HomePrescriptionCardGlassChip(label: Strings.quick),
                    HomePrescriptionCardGlassChip(label: Strings.safe),
                    HomePrescriptionCardGlassChip(label: Strings.reliable),
                  ],
                ),
                10.verticalSpace,
                HomePrescriptionCardUploadButton(onTap: onUploadTap),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// lib/src/home/view/widget/home_prescription_card.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:tsuite/res/constants/assets.dart';
import 'package:tsuite/res/constants/medpik_svg_assets.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';

class HomePrescriptionCard extends StatelessWidget {
  const HomePrescriptionCard({super.key, this.onUploadTap});

  final VoidCallback? onUploadTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final radius = BorderRadius.circular(20.r);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: ColorPalette.glassCardShadow,
      ),
      child: SmoothClipRRect(
        smoothness: 2,
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: ColorPalette.glassSurface,
              borderRadius: radius,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ColorPalette.white.withValues(alpha: 0.28),
                  ColorPalette.white.withValues(alpha: 0.02),
                ],
              ),
              border: Border.all(color: ColorPalette.glassBorderTop, width: 1),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -40.r,
                  left: -30.r,
                  child: _RadialGlow(
                    size: 150.r,
                    color: ColorPalette.glassHighlightWarm,
                  ),
                ),
                Positioned(
                  bottom: -50.r,
                  right: -20.r,
                  child: _RadialGlow(
                    size: 170.r,
                    color: ColorPalette.glassHighlightTeal,
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: radius,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.center,
                        colors: [
                          ColorPalette.glassInnerHighlight,
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
                        style: FontPalette.base700(
                          18,
                          color: colors.primaryText,
                        ),
                      ),
                      3.verticalSpace,
                      Text(
                        Strings.uploadPrescriptionSubtitle,
                        style: FontPalette.base400(
                          12,
                          color: colors.secondaryText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      8.verticalSpace,
                      Wrap(
                        spacing: 10.w,
                        runSpacing: 8.h,
                        children: const [
                          _GlassChip(label: Strings.quick),
                          _GlassChip(label: Strings.safe),
                          _GlassChip(label: Strings.reliable),
                        ],
                      ),
                      10.verticalSpace,
                      _UploadButton(onTap: onUploadTap),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RadialGlow extends StatelessWidget {
  const _RadialGlow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withValues(alpha: 0.0)],
          ),
        ),
      ),
    );
  }
}

class _UploadButton extends StatelessWidget {
  const _UploadButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(100.r);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: ColorPalette.black.withValues(alpha: 0.08),
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
              color: ColorPalette.white.withValues(alpha: 0.88),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ColorPalette.white.withValues(alpha: 0.95),
                  ColorPalette.white.withValues(alpha: 0.72),
                ],
              ),
              border: Border.all(
                color: ColorPalette.white.withValues(alpha: 0.9),
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
                                color: ColorPalette.black,
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

class _GlassChip extends StatelessWidget {
  const _GlassChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return ClipRRect(
      borderRadius: BorderRadius.circular(100.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: ColorPalette.glassChipFill,
            borderRadius: BorderRadius.circular(100.r),
            border: Border.all(
              color: ColorPalette.white.withValues(alpha: 0.55),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                size: 11.r,
                color: ColorPalette.prescriptionIconTeal,
              ),
              3.horizontalSpace,
              Text(
                label,
                style: FontPalette.base500(10, color: colors.primaryText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

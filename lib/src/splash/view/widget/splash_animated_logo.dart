// lib/src/splash/view/widget/splash_animated_logo.dart
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/utils/common_widgets/medpik_logo.dart';

/// Entrance animation for the vertical Medpik lockup on splash.
class SplashAnimatedLogo extends StatefulWidget {
  const SplashAnimatedLogo({super.key});

  @override
  State<SplashAnimatedLogo> createState() => _SplashAnimatedLogoState();
}

class _SplashAnimatedLogoState extends State<SplashAnimatedLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _taglineFade;
  late final Animation<Offset> _taglineSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _logoFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.5, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.92, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.6, curve: Curves.easeOut),
      ),
    );

    _taglineFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 1, curve: Curves.easeOut),
    );
    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 1, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final logoWidth = math.min(screenWidth - 80.w, 220.w);

    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: FadeTransition(
            opacity: _logoFade,
            child: ScaleTransition(
              scale: _logoScale,
              alignment: Alignment.center,
              child: SizedBox(
                width: logoWidth,
                child: ClipRect(
                  child: Align(
                    alignment: Alignment.topCenter,
                    heightFactor: 0.84,
                    child: MedpikLogo(
                      variant: MedpikLogoVariant.vertical,
                      width: logoWidth,
                      fit: BoxFit.contain,
                      plateStyle: MedpikLogoPlateStyle.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        4.verticalSpace,
        FadeTransition(
          opacity: _taglineFade,
          child: SlideTransition(
            position: _taglineSlide,
            child: Transform.translate(
              offset: Offset(0, -6.h),
              child: Text(
                Strings.splashTagline,
                style: FontPalette.base400(15, color: colors.primaryText),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
      ),
    );
  }
}

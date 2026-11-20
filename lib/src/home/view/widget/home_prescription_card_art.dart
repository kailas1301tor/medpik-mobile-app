// lib/src/home/view/widget/home_prescription_card_art.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gif_view/gif_view.dart';
import 'package:medpik/res/constants/medpik_image_assets.dart';
import 'package:medpik/res/styles/color_palette.dart';

/// Prescription card illustration — fades in, plays once, freezes on last frame.
class HomePrescriptionCardArt extends StatefulWidget {
  const HomePrescriptionCardArt({super.key});

  @override
  State<HomePrescriptionCardArt> createState() =>
      _HomePrescriptionCardArtState();
}

class _HomePrescriptionCardArtState extends State<HomePrescriptionCardArt>
    with SingleTickerProviderStateMixin {
  late final GifController _gifController;
  late final AnimationController _enterController;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _gifController = GifController();
    _enterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _fade = CurvedAnimation(
      parent: _enterController,
      curve: Curves.easeOutCubic,
    );
    _scale = Tween<double>(begin: 0.92, end: 1).animate(
      CurvedAnimation(parent: _enterController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _enterController.dispose();
    _gifController.dispose();
    super.dispose();
  }

  void _onGifLoaded(int totalFrames) {
    if (!mounted) return;
    if (_enterController.status == AnimationStatus.dismissed) {
      _enterController.forward();
    }
    // Keep last frame after one-shot play finishes via loop:false.
    if (totalFrames <= 0) return;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 108.r,
          height: 108.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorPalette.prescriptionBannerBg.withValues(alpha: 0.85),
          ),
        ),
        FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: GifView.asset(
              MedpikImageAssets.homePrescriptionUploadArt,
              controller: _gifController,
              width: 118.w,
              height: 128.h,
              fit: BoxFit.contain,
              loop: false,
              autoPlay: true,
              withOpacityAnimation: true,
              onLoaded: _onGifLoaded,
            ),
          ),
        ),
      ],
    );
  }
}

// lib/src/product_detail/view/widget/product_detail_icon_helper.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tsuite/res/constants/medpik_svg_assets.dart';

class ProductDetailIconHelper {
  const ProductDetailIconHelper._();

  static bool usesCalendarAsset(String iconKey) {
    return switch (iconKey) {
      'schedule' || 'calendar' || 'time' || 'clock' || 'date' => true,
      _ => false,
    };
  }

  static Widget build({
    required String iconKey,
    required double size,
    required Color color,
  }) {
    if (usesCalendarAsset(iconKey)) {
      return SvgPicture.asset(
        MedpikSvgAssets.calendar,
        width: size,
        height: size,
        fit: BoxFit.contain,
      );
    }

    return Icon(
      iconForKey(iconKey),
      size: size,
      color: color,
    );
  }

  static IconData iconForKey(String iconKey) {
    return switch (iconKey) {
      'shield' => Icons.shield_outlined,
      'verified' => Icons.verified_user_outlined,
      'science' => Icons.science_outlined,
      'beaker' => Icons.biotech_outlined,
      'medal' => Icons.workspace_premium_outlined,
      'healing' => Icons.healing_outlined,
      'thermometer' => Icons.thermostat_outlined,
      'schedule' || 'calendar' || 'time' || 'clock' || 'date' =>
        Icons.calendar_today_outlined,
      _ => Icons.check_circle_outline_rounded,
    };
  }
}

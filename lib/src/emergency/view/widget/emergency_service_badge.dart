// lib/src/emergency/view/widget/emergency_service_badge.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';

class EmergencyServiceBadge extends StatelessWidget {
  const EmergencyServiceBadge({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: 46.r,
      height: 46.r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primary.withValues(alpha: 0.16),
            colors.primary.withValues(alpha: 0.06),
          ],
        ),
      ),
      child: Center(
        child: Container(
          width: 30.r,
          height: 30.r,
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 18.r, color: colors.primary),
        ),
      ),
    );
  }
}

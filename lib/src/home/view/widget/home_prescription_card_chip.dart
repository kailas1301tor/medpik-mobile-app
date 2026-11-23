// lib/src/home/view/widget/home_prescription_card_chip.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';

/// Outlined pill CTA used for Call / WhatsApp on the home prescription card.
class HomePrescriptionCardOutlineButton extends StatelessWidget {
  const HomePrescriptionCardOutlineButton({
    super.key,
    required this.label,
    required this.iconAsset,
    this.onTap,
  });

  final String label;
  final String iconAsset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final radius = BorderRadius.circular(100.r);
    final borderColor = ColorPalette.primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fill = isDark ? colors.cardBackground : ColorPalette.white;

    return Material(
      color: ColorPalette.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        splashColor: borderColor.withValues(alpha: 0.08),
        highlightColor: borderColor.withValues(alpha: 0.04),
        child: Ink(
          height: 34.h,
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            color: fill,
            borderRadius: radius,
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconAsset,
                width: 14.r,
                height: 14.r,
                colorFilter: ColorFilter.mode(borderColor, BlendMode.srcIn),
              ),
              4.horizontalSpace,
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FontPalette.base600(10, color: colors.primaryText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

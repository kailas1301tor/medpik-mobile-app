// lib/src/checkout/view/widget/checkout_section_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';

class CheckoutSectionCard extends StatelessWidget {
  const CheckoutSectionCard({
    super.key,
    required this.child,
    this.title,
    this.titleIcon,
    this.trailing,
    this.padding,
  });

  final Widget child;
  final String? title;
  final IconData? titleIcon;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final hasHeader = title != null || trailing != null;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: ColorPalette.black.withValues(alpha: 0.06),
            blurRadius: 26.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: SmoothContainer(
        smoothness: 2,
        borderRadius: BorderRadius.circular(20.r),
        color: colors.surface,
        padding: padding ?? EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasHeader) ...[
              Row(
                children: [
                  if (titleIcon != null) ...[
                    _CheckoutSectionIcon(icon: titleIcon!),
                    10.horizontalSpace,
                  ],
                  if (title != null)
                    Expanded(
                      child: Text(
                        title ?? '',
                        style: FontPalette.base700(
                          16,
                          color: colors.primaryText,
                        ),
                      ),
                    )
                  else
                    const Spacer(),
                  if (trailing != null) trailing!,
                ],
              ),
              14.verticalSpace,
            ],
            child,
          ],
        ),
      ),
    );
  }
}

class _CheckoutSectionIcon extends StatelessWidget {
  const _CheckoutSectionIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SmoothContainer(
      smoothness: 2,
      width: 28.r,
      height: 28.r,
      borderRadius: BorderRadius.circular(10.r),
      color: colors.primary.withValues(alpha: 0.12),
      child: Icon(icon, size: 16.r, color: colors.primary),
    );
  }
}

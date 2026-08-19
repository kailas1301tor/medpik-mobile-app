// lib/src/orders/view/widget/order_detail_section_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';

class OrderDetailSectionCard extends StatelessWidget {
  const OrderDetailSectionCard({
    super.key,
    required this.child,
    this.title,
    this.titleIcon,
    this.trailing,
    this.padding,
    this.color,
  });

  final Widget child;
  final String? title;
  final IconData? titleIcon;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final radius = BorderRadius.circular(20.r);
    final hasHeader = title != null || trailing != null;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: ColorPalette.black.withValues(alpha: 0.08),
            blurRadius: 28.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: SmoothContainer(
        smoothness: 2,
        borderRadius: radius,
        color: color ?? colors.surface,
        padding: padding ?? EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasHeader) ...[
              Row(
                children: [
                  if (titleIcon != null) ...[
                    _OrderDetailSectionIcon(icon: titleIcon!),
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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

class _OrderDetailSectionIcon extends StatelessWidget {
  const _OrderDetailSectionIcon({required this.icon});

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

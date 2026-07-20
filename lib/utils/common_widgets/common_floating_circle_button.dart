// lib/utils/common_widgets/common_floating_circle_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/styles/color_palette.dart';

/// Shared circular chrome for hero-overlay controls (back, wishlist, etc.).
class CommonFloatingCircleButton extends StatelessWidget {
  const CommonFloatingCircleButton({
    super.key,
    required this.onTap,
    required this.child,
    this.size,
    this.margin,
    this.overlayStyle = false,
  });

  final VoidCallback onTap;
  final Widget child;
  final double? size;
  final EdgeInsetsGeometry? margin;
  /// High-contrast styling for controls on top of product photos.
  final bool overlayStyle;

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color backgroundColor(
    BuildContext context, {
    bool overlayStyle = false,
  }) {
    if (overlayStyle) return ColorPalette.white;
    return isDark(context)
        ? ColorPalette.white.withValues(alpha: 0.12)
        : ColorPalette.white;
  }

  static Color borderColor(
    BuildContext context, {
    bool overlayStyle = false,
  }) {
    if (overlayStyle) {
      return ColorPalette.black.withValues(alpha: 0.08);
    }
    return isDark(context)
        ? ColorPalette.white.withValues(alpha: 0.16)
        : ColorPalette.black.withValues(alpha: 0.08);
  }

  /// Icon / inactive glyph color for overlay controls.
  static Color foregroundColor(
    BuildContext context, {
    bool overlayStyle = false,
  }) {
    if (overlayStyle) return ColorPalette.f191B1E;
    return isDark(context) ? ColorPalette.white : ColorPalette.f191B1E;
  }

  @override
  Widget build(BuildContext context) {
    final buttonSize = size ?? 44.r;
    final resolvedMargin = margin ?? EdgeInsets.all(6.r);

    return Padding(
      padding: resolvedMargin,
      child: Material(
        color: backgroundColor(context, overlayStyle: overlayStyle),
        elevation: overlayStyle ? 2 : 0,
        shadowColor: overlayStyle
            ? ColorPalette.black.withValues(alpha: 0.12)
            : null,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Ink(
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: borderColor(context, overlayStyle: overlayStyle),
              ),
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

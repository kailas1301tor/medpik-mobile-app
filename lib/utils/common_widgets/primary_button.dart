// /Users/wac/Documents/wac projects/tsuite/lib/utils/common_widgets/primary_button.dart
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/utils/common_widgets/common_inline_loader.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    this.height,
    this.width,
    this.text,
    this.isLoading = false,
    this.onPressed,
    this.fontStyle,
    this.backgroundColor,
    this.textColor,
    this.prefixIcon,
    this.iconSpacing,
    this.radius,
    this.textScaler,
    this.progressColor,
    this.splashColor,
    this.gradient,
    this.showShimmer = false,
    this.loadingRadius,
    this.borderSide,
  });

  final double? height;
  final double? width;
  final String? text;
  final bool isLoading;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Color? splashColor;
  final TextStyle? fontStyle;
  final Color? textColor;
  final Widget? prefixIcon;
  final double? iconSpacing;
  final double? radius;
  final TextScaler? textScaler;
  final Color? progressColor;
  final bool showShimmer;
  final double? loadingRadius;
  final BorderSide? borderSide;

  static const LinearGradient _defaultGradient = ColorPalette.primaryGradient;

  bool get _isDisabled => onPressed == null;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = (radius ?? 100).r;
    final isInteractable = !_isDisabled && !isLoading;
    final smoothShape = SmoothRectangleBorder(
      borderRadius: SmoothBorderRadius(
        cornerRadius: effectiveRadius,
        cornerSmoothing: 1,
      ),
      side: borderSide ?? BorderSide.none,
    );

    final effectiveGradient = _isDisabled
        ? LinearGradient(
            colors: [
              context.appColors.primary.withValues(alpha: 0.12),
              context.appColors.primary.withValues(alpha: 0.12),
            ],
          )
        : gradient ?? _defaultGradient;

    return SizedBox(
      width: width,
      height: (height ?? 51).h,
      child: Stack(
      children: [
        Positioned.fill(
          child: Container(
          decoration: ShapeDecoration(
            shape: smoothShape,
            color: backgroundColor,
            gradient: backgroundColor == null ? effectiveGradient : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isInteractable ? onPressed : null,
              customBorder: smoothShape,
              splashColor:
                  splashColor ?? ColorPalette.black.withValues(alpha: 0.05),
              highlightColor: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Center(
                  child: isLoading
                      ? CommonInlineLoader(
                          size: (loadingRadius ?? 14.r) * 2,
                          color: progressColor ?? ColorPalette.white,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (prefixIcon != null) ...[
                              prefixIcon!,
                              SizedBox(width: iconSpacing ?? 8.w),
                            ],
                            Flexible(
                              child: Text(
                                text ?? '',
                                textScaler: textScaler,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    fontStyle ??
                                    FontPalette.base600(
                                      16,
                                      color: _isDisabled
                                          ? context.appColors.primary.withValues(alpha: 0.4)
                                          : textColor ?? ColorPalette.white,
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
        ),
        if (showShimmer && isInteractable)
          Positioned.fill(
            child: IgnorePointer(
              child: ClipSmoothRect(
                radius: SmoothBorderRadius(
                  cornerRadius: effectiveRadius,
                  cornerSmoothing: 1,
                ),
                child: Shimmer.fromColors(
                  baseColor: Colors.transparent,
                  highlightColor: ColorPalette.white.withValues(alpha: 0.15),
                  child: const ColoredBox(color: ColorPalette.white),
                ),
              ),
            ),
          ),
      ],
      ),
    );
  }
}

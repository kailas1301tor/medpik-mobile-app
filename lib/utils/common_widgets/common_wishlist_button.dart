// lib/utils/common_widgets/common_wishlist_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/utils/common_widgets/common_floating_circle_button.dart';

/// Shared favorite control used on product cards, detail, and grids.
///
/// Active state is red; toggling plays a short bounce animation.
class CommonWishlistButton extends StatefulWidget {
  const CommonWishlistButton({
    super.key,
    required this.isWishlisted,
    required this.onTap,
    this.size,
    this.iconSize,
    this.backgroundColor,
    this.inactiveColor,
    this.showShadow = true,
    this.overlayStyle = false,
    this.margin,
    this.isLoading = false,
  });

  final bool isWishlisted;
  final VoidCallback onTap;
  final double? size;
  final double? iconSize;
  final Color? backgroundColor;
  final Color? inactiveColor;
  final bool showShadow;
  /// Matches [CommonBackButton] frosted/dark circle on hero overlays.
  final bool overlayStyle;
  final EdgeInsetsGeometry? margin;
  final bool isLoading;

  @override
  State<CommonWishlistButton> createState() => _CommonWishlistButtonState();
}

class _CommonWishlistButtonState extends State<CommonWishlistButton>
    with TickerProviderStateMixin {
  late final AnimationController _bounceController;
  late final AnimationController _loadingController;
  late final Animation<double> _bounceScale;
  late final Animation<double> _loadingScale;
  late final Animation<double> _loadingOpacity;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _bounceScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 1.35)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.35, end: 0.9)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.9, end: 1)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 30,
      ),
    ]).animate(_bounceController);

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _loadingScale = Tween<double>(begin: 0.88, end: 1.14).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.easeInOut),
    );
    _loadingOpacity = Tween<double>(begin: 0.45, end: 1).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.easeInOut),
    );

    if (widget.isLoading) {
      _loadingController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant CommonWishlistButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isLoading && !oldWidget.isLoading) {
      _loadingController.repeat(reverse: true);
    } else if (!widget.isLoading && oldWidget.isLoading) {
      _loadingController.stop();
      _loadingController.reset();
    }

    if (!widget.isLoading &&
        oldWidget.isWishlisted != widget.isWishlisted) {
      _bounceController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  Widget _buildHeartGlyph({
    required double iconSize,
    required Color color,
    required bool filled,
  }) {
    return Icon(
      filled ? Icons.favorite_rounded : Icons.favorite_border_rounded,
      size: iconSize,
      color: color,
    );
  }

  Widget _buildHeartIcon({
    required double iconSize,
    required Color inactiveColor,
  }) {
    final heartColor = widget.isWishlisted
        ? ColorPalette.wishlistHeart
        : inactiveColor;
    final filled = widget.isWishlisted;

    if (widget.isLoading) {
      return ScaleTransition(
        scale: _loadingScale,
        child: FadeTransition(
          opacity: _loadingOpacity,
          child: _buildHeartGlyph(
            iconSize: iconSize,
            color: heartColor,
            filled: filled,
          ),
        ),
      );
    }

    return ScaleTransition(
      scale: _bounceScale,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          );
        },
        child: KeyedSubtree(
          key: ValueKey<bool>(widget.isWishlisted),
          child: _buildHeartGlyph(
            iconSize: iconSize,
            color: heartColor,
            filled: filled,
          ),
        ),
      ),
    );
  }

  Color _resolveInactiveColor(BuildContext context, AppColors colors) {
    if (widget.inactiveColor != null) return widget.inactiveColor!;

    if (widget.overlayStyle) {
      return CommonFloatingCircleButton.foregroundColor(
        context,
        overlayStyle: true,
      );
    }

    // Default circle fill is white on product heroes — keep icon dark in dark mode.
    final circleFill = widget.backgroundColor ?? ColorPalette.white;
    final isLightCircle =
        ThemeData.estimateBrightnessForColor(circleFill) == Brightness.light;
    if (isLightCircle) {
      return ColorPalette.f191B1E.withValues(alpha: 0.55);
    }

    return colors.primaryText.withValues(alpha: 0.55);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final size = widget.size ?? (widget.overlayStyle ? 44.r : 30.r);
    final iconSize = widget.iconSize ?? (widget.overlayStyle ? 20.r : 16.r);
    final inactiveColor = _resolveInactiveColor(context, colors);
    final onTap = widget.isLoading ? () {} : widget.onTap;

    final heart = _buildHeartIcon(
      iconSize: iconSize,
      inactiveColor: inactiveColor,
    );

    if (widget.overlayStyle) {
      return CommonFloatingCircleButton(
        onTap: onTap,
        size: size,
        margin: widget.margin,
        overlayStyle: true,
        child: heart,
      );
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? ColorPalette.white,
          shape: BoxShape.circle,
          boxShadow: widget.showShadow
              ? [
                  BoxShadow(
                    color: ColorPalette.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(child: heart),
      ),
    );
  }
}

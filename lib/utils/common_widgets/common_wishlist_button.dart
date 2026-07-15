// lib/utils/common_widgets/common_wishlist_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/styles/color_palette.dart';

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
  });

  final bool isWishlisted;
  final VoidCallback onTap;
  final double? size;
  final double? iconSize;
  final Color? backgroundColor;
  final Color? inactiveColor;
  final bool showShadow;

  @override
  State<CommonWishlistButton> createState() => _CommonWishlistButtonState();
}

class _CommonWishlistButtonState extends State<CommonWishlistButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _scale = TweenSequence<double>([
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
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant CommonWishlistButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isWishlisted != widget.isWishlisted) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final size = widget.size ?? 30.r;
    final iconSize = widget.iconSize ?? 16.r;
    final inactiveColor =
        widget.inactiveColor ?? colors.primaryText.withValues(alpha: 0.55);
    final heartColor = widget.isWishlisted
        ? ColorPalette.wishlistHeart
        : inactiveColor;

    return GestureDetector(
      onTap: widget.onTap,
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
        child: Center(
          child: ScaleTransition(
            scale: _scale,
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
              child: Icon(
                widget.isWishlisted
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                key: ValueKey<bool>(widget.isWishlisted),
                size: iconSize,
                color: heartColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

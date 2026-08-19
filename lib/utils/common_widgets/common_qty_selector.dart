// lib/utils/common_widgets/common_qty_selector.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';

class CommonQtySelector extends StatelessWidget {
  const CommonQtySelector({
    super.key,
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
    this.compact = false,
  });

  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final height = compact ? 30.h : 36.h;
    final buttonSize = compact ? 26.r : 30.r;
    final iconSize = compact ? 14.r : 16.r;
    final fontSize = compact ? 11.0 : 12.0;
    final qtyWidth = compact ? 26.w : 32.w;

    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        color: colors.inputBackground.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QtySegmentButton(
            icon: Icons.remove_rounded,
            onTap: onDecrement,
            size: buttonSize,
            iconSize: iconSize,
          ),
          SizedBox(
            width: qtyWidth,
            child: Center(
              child: Text(
                '$quantity',
                style: FontPalette.base700(fontSize, color: colors.primaryText),
              ),
            ),
          ),
          _QtySegmentButton(
            icon: Icons.add_rounded,
            onTap: onIncrement,
            size: buttonSize,
            iconSize: iconSize,
          ),
        ],
      ),
    );
  }
}

class _QtySegmentButton extends StatelessWidget {
  const _QtySegmentButton({
    required this.icon,
    required this.onTap,
    required this.size,
    required this.iconSize,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Material(
      color: ColorPalette.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999.r),
        child: SizedBox(
          width: size,
          height: size,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: iconSize, color: colors.primary),
          ),
        ),
      ),
    );
  }
}

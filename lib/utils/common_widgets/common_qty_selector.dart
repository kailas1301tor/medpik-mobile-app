// lib/utils/common_widgets/common_qty_selector.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';

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
    final height = compact ? 26.h : 34.h;
    final fontSize = compact ? 10.0 : 12.0;
    final tapSize = compact ? 20.r : 26.r;
    final iconSize = compact ? 12.r : 16.r;
    final horizontalPadding = compact ? 2.w : 4.w;
    final countPadding = compact ? 4.w : 6.w;

    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: ColorPalette.productAccentTeal,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QtyTap(
            icon: Icons.remove_rounded,
            onTap: onDecrement,
            size: tapSize,
            iconSize: iconSize,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: countPadding),
            child: Text(
              '$quantity',
              style: FontPalette.base700(fontSize, color: ColorPalette.white),
            ),
          ),
          _QtyTap(
            icon: Icons.add_rounded,
            onTap: onIncrement,
            size: tapSize,
            iconSize: iconSize,
          ),
        ],
      ),
    );
  }
}

class _QtyTap extends StatelessWidget {
  const _QtyTap({
    required this.icon,
    required this.onTap,
    this.size,
    this.iconSize,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double? size;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: size ?? 26.r,
        height: size ?? 26.r,
        child: Icon(icon, size: iconSize ?? 16.r, color: ColorPalette.white),
      ),
    );
  }
}

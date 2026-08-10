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
    final height = compact ? 28.h : 34.h;
    final segmentSize = compact ? 28.r : 34.r;
    final iconSize = compact ? 14.r : 16.r;
    final fontSize = compact ? 11.0 : 12.0;
    final qtyWidth = compact ? 24.w : 28.w;
    final borderRadius = compact ? 8.r : 10.r;

    return Container(
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: colors.inputBorder, width: 1.w),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _QtySegmentButton(
              icon: Icons.remove_rounded,
              onTap: onDecrement,
              size: segmentSize,
              iconSize: iconSize,
            ),
            VerticalDivider(
              width: 1.w,
              thickness: 1,
              color: colors.inputBorder,
            ),
            SizedBox(
              width: qtyWidth,
              child: Center(
                child: Text(
                  '$quantity',
                  style: FontPalette.base700(
                    fontSize,
                    color: colors.primaryText,
                  ),
                ),
              ),
            ),
            VerticalDivider(
              width: 1.w,
              thickness: 1,
              color: colors.inputBorder,
            ),
            _QtySegmentButton(
              icon: Icons.add_rounded,
              onTap: onIncrement,
              size: segmentSize,
              iconSize: iconSize,
            ),
          ],
        ),
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
    return Material(
      color: ColorPalette.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            size: iconSize,
            color: ColorPalette.productAccentTeal,
          ),
        ),
      ),
    );
  }
}

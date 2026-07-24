// lib/src/product_detail/view/widget/product_detail_qty_stepper.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';

class ProductDetailQtyStepper extends StatelessWidget {
  const ProductDetailQtyStepper({
    super.key,
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
    this.allowRemoveAtOne = false,
  });

  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  /// When true, minus stays enabled at qty 1 (e.g. remove cart line).
  final bool allowRemoveAtOne;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final canDecrement = allowRemoveAtOne || quantity > 1;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepButton(
          icon: Icons.remove_rounded,
          onTap: canDecrement ? onDecrement : null,
          enabled: canDecrement,
        ),
        12.horizontalSpace,
        SizedBox(
          width: 20.w,
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: FontPalette.base700(16, color: colors.primaryText),
          ),
        ),
        12.horizontalSpace,
        _StepButton(
          icon: Icons.add_rounded,
          onTap: onIncrement,
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final iconColor = enabled
        ? ColorPalette.productAccentTeal
        : ColorPalette.productAccentTeal.withValues(alpha: 0.35);

    return Material(
      color: ColorPalette.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        customBorder: const CircleBorder(),
        child: Ink(
          width: 48.r,
          height: 48.r,
          decoration: BoxDecoration(
            color: ColorPalette.productAccentTeal.withValues(
              alpha: enabled ? 0.12 : 0.06,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18.r, color: iconColor),
        ),
      ),
    );
  }
}

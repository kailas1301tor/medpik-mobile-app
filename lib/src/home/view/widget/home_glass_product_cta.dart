// lib/src/home/view/widget/home_glass_product_cta.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/cart/notifier/cart_notifier.dart';

class HomeGlassProductCta extends ConsumerWidget {
  const HomeGlassProductCta({
    super.key,
    required this.product,
    this.compact = false,
  });

  final ProductModel product;
  final bool compact;

  int _quantity(WidgetRef ref) {
    final items = ref.watch(cartNotifierProvider.select((s) => s.items));
    for (final item in items) {
      if (item.product.id == product.id) return item.quantity;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantity = _quantity(ref);
    final cartNotifier = ref.read(cartNotifierProvider.notifier);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: quantity == 0
          ? _AddButton(
              key: const ValueKey('add'),
              compact: compact,
              onTap: () => cartNotifier.addItem(product: product, quantity: 1),
            )
          : _QtySelector(
              key: const ValueKey('qty'),
              quantity: quantity,
              compact: compact,
              onDecrement: () => cartNotifier.decrementItem(product.id),
              onIncrement: () => cartNotifier.incrementItem(product.id),
            ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({
    super.key,
    required this.onTap,
    this.compact = false,
  });

  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 32.r : 34.r;
    final iconSize = compact ? 16.r : 18.r;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: ColorPalette.productAccentTeal,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: ColorPalette.productAccentTeal.withValues(alpha: 0.28),
              blurRadius: compact ? 6 : 10,
              offset: Offset(0, compact ? 2 : 4),
            ),
          ],
        ),
        child: Icon(
          Icons.add_rounded,
          size: iconSize,
          color: ColorPalette.white,
        ),
      ),
    );
  }
}

class _QtySelector extends StatelessWidget {
  const _QtySelector({
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
          _QtyTap(icon: Icons.remove_rounded, onTap: onDecrement, size: tapSize, iconSize: iconSize),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: countPadding),
            child: Text(
              '$quantity',
              style: FontPalette.base700(fontSize, color: ColorPalette.white),
            ),
          ),
          _QtyTap(icon: Icons.add_rounded, onTap: onIncrement, size: tapSize, iconSize: iconSize),
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

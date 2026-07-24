// lib/utils/common_widgets/cart_mutation_overlay.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medpik/providers/cart_providers.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/utils/common_widgets/common_loader.dart';

/// Blocks interaction and shows a dimmed loader while cart mutations are in flight.
///
/// Always keeps [child] in a stable [Stack] so descendants are not reparented
/// when [isMutating] toggles (avoids image reloads on product detail, etc.).
class CartMutationOverlay extends ConsumerWidget {
  const CartMutationOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMutating = ref.watch(
      cartNotifierProvider.select((s) => s.isMutating),
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        if (isMutating)
          Positioned.fill(
            child: ColoredBox(
              color: ColorPalette.black.withValues(alpha: 0.25),
              child: const CommonLoader(),
            ),
          ),
      ],
    );
  }
}

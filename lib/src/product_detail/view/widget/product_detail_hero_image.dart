// lib/src/product_detail/view/widget/product_detail_hero_image.dart
import 'package:flutter/material.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/utils/common_widgets/common_cached_network_image.dart';
import 'package:medpik/utils/extensions/context_extensions.dart';

class ProductDetailHeroImage extends StatelessWidget {
  const ProductDetailHeroImage({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  static double heightFor(BuildContext context) =>
      context.screenHeight * 0.42;

  @override
  Widget build(BuildContext context) {
    final heroHeight = heightFor(context);

    return SizedBox(
      height: heroHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CommonCachedNetworkImage(
            imageUrl: imageUrl,
            width: double.infinity,
            height: heroHeight,
            borderRadius: 0,
            fit: BoxFit.cover,
            memCacheMax: 800,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ColorPalette.black.withValues(alpha: 0.08),
                  ColorPalette.black.withValues(alpha: 0.02),
                  ColorPalette.black.withValues(alpha: 0.18),
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

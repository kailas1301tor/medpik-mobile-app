// lib/utils/common_widgets/common_glass_product_image_hero.dart
import 'package:flutter/material.dart';
import 'package:medpik/data/models/product_model.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/utils/common_widgets/common_cached_network_image.dart';
import 'package:medpik/utils/helpers/image_mem_cache_helper.dart';

class CommonGlassProductImageHero extends StatelessWidget {
  const CommonGlassProductImageHero({
    super.key,
    required this.product,
    required this.height,
    this.contained = false,
    this.topRadius,
    this.memCacheWidth,
    this.memCacheHeight,
  });

  final ProductModel product;
  final double height;
  final bool contained;
  final double? topRadius;
  final int? memCacheWidth;
  final int? memCacheHeight;

  @override
  Widget build(BuildContext context) {
    final imageSize = contained ? height * 0.72 : null;
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final resolvedMemCache = ImageMemCacheHelper.resolve(
      logicalWidth: contained ? (imageSize ?? height) : null,
      logicalHeight: contained ? imageSize : height,
      devicePixelRatio: dpr,
      fallbackLogicalWidth: contained ? null : screenWidth / 2,
      min: contained ? 100 : 150,
      max: 300,
    );

    return ClipRRect(
      borderRadius: topRadius == null
          ? BorderRadius.zero
          : BorderRadius.vertical(top: Radius.circular(topRadius!)),
      child: Container(
        height: height,
        width: double.infinity,
        color: ColorPalette.productImageBg,
        alignment: Alignment.center,
        child: CommonCachedNetworkImage(
          imageUrl: product.imageUrl,
          width: contained ? imageSize : double.infinity,
          height: contained ? imageSize : height,
          fit: contained ? BoxFit.contain : BoxFit.cover,
          memCacheWidth: memCacheWidth ?? resolvedMemCache.width,
          memCacheHeight: memCacheHeight ?? resolvedMemCache.height,
          borderRadius: 0,
        ),
      ),
    );
  }
}

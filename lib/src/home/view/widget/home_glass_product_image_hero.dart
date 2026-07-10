// lib/src/home/view/widget/home_glass_product_image_hero.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/utils/common_widgets/common_cached_network_image.dart';

class HomeGlassProductImageHero extends StatelessWidget {
  const HomeGlassProductImageHero({
    super.key,
    required this.product,
    required this.height,
  });

  final ProductModel product;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      color: ColorPalette.productImageBg,
      alignment: Alignment.center,
      child: CommonCachedNetworkImage(
        imageUrl: product.imageUrl,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        memCacheWidth: 400,
        memCacheHeight: 400,
        borderRadius: 0,
        errorWidget: Icon(
          Icons.medication_outlined,
          size: 36.r,
          color: ColorPalette.prescriptionIconTeal,
        ),
      ),
    );
  }
}

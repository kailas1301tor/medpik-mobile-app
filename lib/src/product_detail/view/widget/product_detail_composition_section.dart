// lib/src/product_detail/view/widget/product_detail_composition_section.dart
import 'package:flutter/material.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_info_block.dart';

class ProductDetailCompositionSection extends StatelessWidget {
  const ProductDetailCompositionSection({
    super.key,
    required this.composition,
  });

  final String composition;

  @override
  Widget build(BuildContext context) {
    return ProductDetailInfoBlock(
      title: Strings.composition,
      body: composition,
      icon: Icons.science_outlined,
    );
  }
}

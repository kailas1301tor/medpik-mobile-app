// lib/src/product_detail/view/widget/product_detail_uses_section.dart
import 'package:flutter/material.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_info_block.dart';

class ProductDetailUsesSection extends StatelessWidget {
  const ProductDetailUsesSection({
    super.key,
    required this.uses,
  });

  final String uses;

  @override
  Widget build(BuildContext context) {
    return ProductDetailInfoBlock(
      title: Strings.uses,
      body: uses,
      icon: Icons.healing_outlined,
    );
  }
}

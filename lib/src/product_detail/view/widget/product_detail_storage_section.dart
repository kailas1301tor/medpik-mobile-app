// lib/src/product_detail/view/widget/product_detail_storage_section.dart
import 'package:flutter/material.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/src/product_detail/view/widget/product_detail_info_block.dart';

class ProductDetailStorageSection extends StatelessWidget {
  const ProductDetailStorageSection({
    super.key,
    required this.storageBody,
  });

  final String storageBody;

  @override
  Widget build(BuildContext context) {
    return ProductDetailInfoBlock(
      title: Strings.storageAndHandling,
      body: storageBody,
      icon: Icons.inventory_2_outlined,
    );
  }
}

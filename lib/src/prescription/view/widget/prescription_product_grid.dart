// lib/src/prescription/view/widget/prescription_product_grid.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/src/prescription/view/widget/prescription_product_grid_tile.dart';

class PrescriptionProductGrid extends StatelessWidget {
  const PrescriptionProductGrid({super.key, required this.products});

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, index) {
        return Align(
          alignment: Alignment.topCenter,
          child: PrescriptionProductGridTile(product: products[index]),
        );
      },
    );
  }
}

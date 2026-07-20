// lib/src/search/view/widget/search_results_content_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/src/search/view/widget/search_product_card.dart';

class SearchResultsContentWidget extends StatelessWidget {
  const SearchResultsContentWidget({super.key, required this.results});

  final List<ProductModel> results;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.62,
      ),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];
        return RepaintBoundary(
          child: SearchProductCard(product: product),
        );
      },
    );
  }
}

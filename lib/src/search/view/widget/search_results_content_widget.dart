// lib/src/search/view/widget/search_results_content_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/search/view/widget/search_product_card.dart';
import 'package:tsuite/src/search/view/widget/search_results_shimmer_widget.dart';

class SearchResultsContentWidget extends StatelessWidget {
  const SearchResultsContentWidget({
    super.key,
    required this.results,
    required this.hasMore,
    required this.isLoadingMore,
    required this.onLoadMore,
  });

  final List<ProductModel> results;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.62,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = results[index];
                return RepaintBoundary(
                  child: SearchProductCard(product: product),
                );
              },
              childCount: results.length,
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: false,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: isLoadingMore
              ? const Center(child: SearchResultsLoadMoreShimmer())
              : hasMore && results.isNotEmpty
                  ? GestureDetector(
                      onTap: onLoadMore,
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.refresh,
                              size: 18.r,
                              color: colors.primary,
                            ),
                            6.horizontalSpace,
                            Text(
                              Strings.loadMore,
                              style: FontPalette.base600(
                                13,
                                color: colors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : 16.verticalSpace,
        ),
        SliverToBoxAdapter(child: 24.verticalSpace),
      ],
    );
  }
}

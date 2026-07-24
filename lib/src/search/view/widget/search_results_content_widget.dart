// lib/src/search/view/widget/search_results_content_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/data/models/product_model.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/search/view/widget/search_product_card.dart';
import 'package:medpik/src/search/view/widget/search_results_shimmer_widget.dart';

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
    final rowCount = (results.length / 2).ceil();

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, rowIndex) {
                final leftIndex = rowIndex * 2;
                final rightIndex = leftIndex + 1;
                final left = results[leftIndex];
                final right = rightIndex < results.length
                    ? results[rightIndex]
                    : null;

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: rowIndex < rowCount - 1 ? 12.h : 0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: SearchProductCard(product: left)),
                      12.horizontalSpace,
                      Expanded(
                        child: right == null
                            ? const SizedBox.shrink()
                            : SearchProductCard(product: right),
                      ),
                    ],
                  ),
                );
              },
              childCount: rowCount,
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: true,
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
                        Icon(Icons.refresh, size: 18.r, color: colors.primary),
                        6.horizontalSpace,
                        Text(
                          Strings.loadMore,
                          style: FontPalette.base600(13, color: colors.primary),
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

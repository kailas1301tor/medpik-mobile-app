// lib/src/search/view/widget/search_results_content_widget.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/data/models/product_model.dart';
import 'package:medpik/src/search/view/widget/search_product_card.dart';
import 'package:medpik/utils/helpers/pagination_scroll_helper.dart';

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
    final rowCount = (results.length / 2).ceil();

    return PaginationScrollListener(
      hasMore: hasMore,
      isLoadingMore: isLoadingMore,
      onLoadMore: onLoadMore,
      child: CustomScrollView(
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
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Center(
                      child: CupertinoActivityIndicator(radius: 10.r),
                    ),
                  )
                : 16.verticalSpace,
          ),
          SliverToBoxAdapter(child: 24.verticalSpace),
        ],
      ),
    );
  }
}

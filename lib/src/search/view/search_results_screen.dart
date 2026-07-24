// lib/src/search/view/search_results_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/data/models/product_catalog_args.dart';
import 'package:medpik/src/search/notifier/search_notifier.dart';
import 'package:medpik/src/search/view/widget/catalog_category_chips.dart';
import 'package:medpik/src/search/view/widget/search_results_content_widget.dart';
import 'package:medpik/src/search/view/widget/search_results_shimmer_widget.dart';
import 'package:medpik/utils/common_widgets/common_app_bar.dart';
import 'package:medpik/utils/common_widgets/common_refresh_indicator.dart';
import 'package:medpik/utils/common_widgets/common_scaffold.dart';
import 'package:medpik/utils/common_widgets/common_search_bar.dart';
import 'package:medpik/utils/common_widgets/common_switch_state.dart';
import 'package:tuple/tuple.dart';

class SearchResultsScreen extends ConsumerWidget {
  const SearchResultsScreen({super.key, required this.args});

  final ProductCatalogArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(searchCatalogInitProvider(args));

    final colors = context.appColors;
    final notifier = ref.read(searchNotifierProvider.notifier);
    final catalogTitle = ref.watch(
      searchNotifierProvider.select((s) => s.catalogTitle),
    );
    final searchData = ref.watch(
      searchNotifierProvider.select(
        (s) => Tuple3(s.loaderState, s.results, s.categoryId),
      ),
    );
    final paging = ref.watch(
      searchNotifierProvider.select(
        (s) => Tuple2(s.hasMore, s.isLoadingMore),
      ),
    );

    final loaderState = searchData.item1;
    final results = searchData.item2;
    final categoryId = searchData.item3;
    final hasMore = paging.item1;
    final isLoadingMore = paging.item2;
    final title = catalogTitle.isNotEmpty ? catalogTitle : args.title;

    return CommonScaffold(
      appBar: CommonAppBar(title: title),
      backgroundColor: colors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 4.h),
            child: CommonSearchBar(
              controller: notifier.catalogSearchController,
              focusNode: notifier.catalogSearchFocusNode,
              hintText: Strings.searchMedicines,
              onChanged: notifier.onCatalogSearchChanged,
              onClear: notifier.clearCatalogSearch,
            ),
          ),
          8.verticalSpace,
          CatalogCategoryChips(
            selectedCategoryId: categoryId,
            onSelected: notifier.selectCategory,
          ),
          4.verticalSpace,
          Expanded(
            child: CommonRefreshIndicator(
              onRefresh: notifier.refreshCatalog,
              child: CommonSwitchState(
                loaderState: loaderState,
                reload: notifier.refreshCatalog,
                loader: const SearchResultsShimmerWidget(),
                buttonText: Strings.refresh,
                child: SearchResultsContentWidget(
                  results: results,
                  hasMore: hasMore,
                  isLoadingMore: isLoadingMore,
                  onLoadMore: notifier.loadMore,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

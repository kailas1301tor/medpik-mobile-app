// lib/src/search/view/search_results_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/src/home/notifier/home_notifier.dart';
import 'package:tsuite/src/search/model/product_catalog_args.dart';
import 'package:tsuite/src/search/notifier/search_notifier.dart';
import 'package:tsuite/src/search/view/widget/catalog_category_chips.dart';
import 'package:tsuite/src/search/view/widget/search_results_content_widget.dart';
import 'package:tsuite/src/search/view/widget/search_results_shimmer_widget.dart';
import 'package:tsuite/utils/common_widgets/common_app_bar.dart';
import 'package:tsuite/utils/common_widgets/common_empty_state.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';
import 'package:tsuite/utils/common_widgets/common_search_bar.dart';
import 'package:tuple/tuple.dart';

class SearchResultsScreen extends ConsumerStatefulWidget {
  const SearchResultsScreen({super.key, required this.args});

  final ProductCatalogArgs args;

  @override
  ConsumerState<SearchResultsScreen> createState() =>
      _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(searchNotifierProvider.notifier).initCatalog(widget.args);
      _ensureHomeCategories();
    });
  }

  void _ensureHomeCategories() {
    final home = ref.read(homeNotifierProvider);
    final categories = home.data?.categories ?? const [];
    if (categories.isEmpty) {
      ref.read(homeNotifierProvider.notifier).fetchHomeFeed();
    }
  }

  @override
  Widget build(BuildContext context) {
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
    final title = catalogTitle.isNotEmpty ? catalogTitle : widget.args.title;

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
            child: switch (loaderState) {
              LoaderState.loading => const SearchResultsShimmerWidget(),
              LoaderState.noData => const CommonEmptyState(
                  title: Strings.noResultsFound,
                  message: Strings.noResultsDesc,
                ),
              LoaderState.error ||
              LoaderState.networkError ||
              LoaderState.serverError =>
                CommonEmptyState(
                  title: Strings.errorTitle,
                  message: Strings.errorDescription,
                  buttonText: Strings.refresh,
                  onPressed: notifier.refreshCatalog,
                ),
              LoaderState.loaded => SearchResultsContentWidget(
                  results: results,
                  hasMore: hasMore,
                  isLoadingMore: isLoadingMore,
                  onLoadMore: notifier.loadMore,
                ),
              _ => const SizedBox.shrink(),
            },
          ),
        ],
      ),
    );
  }
}

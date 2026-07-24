// lib/src/search/view/widget/search_catalog_content_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/src/search/notifier/search_notifier.dart';
import 'package:medpik/src/search/view/widget/search_results_content_widget.dart';
import 'package:medpik/src/search/view/widget/search_results_shimmer_widget.dart';
import 'package:medpik/utils/common_widgets/common_refresh_indicator.dart';
import 'package:medpik/utils/common_widgets/common_switch_state.dart';
import 'package:tuple/tuple.dart';

class SearchCatalogContentWidget extends ConsumerWidget {
  const SearchCatalogContentWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(searchNotifierProvider.notifier);
    final searchData = ref.watch(
      searchNotifierProvider.select(
        (s) => Tuple3(s.loaderState, s.results, s.errorMessage),
      ),
    );
    final paging = ref.watch(
      searchNotifierProvider.select(
        (s) => Tuple2(s.hasMore, s.isLoadingMore),
      ),
    );

    return CommonRefreshIndicator(
      onRefresh: notifier.refreshCatalog,
      child: CommonSwitchState(
        loaderState: searchData.item1,
        reload: notifier.refreshCatalog,
        loader: const SearchResultsShimmerWidget(),
        buttonText: Strings.refresh,
        errorMessage: searchData.item3,
        child: SearchResultsContentWidget(
          results: searchData.item2,
          hasMore: paging.item1,
          isLoadingMore: paging.item2,
          onLoadMore: notifier.loadMore,
        ),
      ),
    );
  }
}

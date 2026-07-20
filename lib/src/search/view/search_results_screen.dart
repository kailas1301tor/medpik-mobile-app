// lib/src/search/view/search_results_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/search/notifier/search_notifier.dart';
import 'package:tsuite/src/search/view/widget/search_results_content_widget.dart';
import 'package:tsuite/utils/common_widgets/common_app_bar.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';
import 'package:tsuite/utils/common_widgets/common_empty_state.dart';
import 'package:tsuite/utils/common_widgets/common_loader.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';
import 'package:tuple/tuple.dart';

class SearchResultsScreen extends ConsumerWidget {
  const SearchResultsScreen({super.key, required this.initialQuery});

  final String initialQuery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final notifier = ref.read(searchNotifierProvider.notifier);
    final searchData = ref.watch(
      searchNotifierProvider.select(
        (s) => Tuple4(
          s.loaderState,
          s.results,
          s.categories,
          s.selectedCategory,
        ),
      ),
    );
    final loaderState = searchData.item1;
    final results = searchData.item2;
    final categories = searchData.item3;
    final selectedCategory = searchData.item4;

    Future.microtask(() => notifier.initResults(initialQuery));

    return CommonScaffold(
      appBar: CommonAppBar(title: '${Strings.resultsFor} "$initialQuery"'),
      backgroundColor: colors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (categories.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 8.h, bottom: 4.h),
              child: SizedBox(
                height: 40.h,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length + 1,
                  separatorBuilder: (_, __) => 8.horizontalSpace,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _FilterChip(
                        label: Strings.allCategories,
                        isSelected: selectedCategory == null,
                        onTap: () => notifier.selectCategory(null),
                      );
                    }
                    final category = categories[index - 1];
                    return _FilterChip(
                      label: category.name,
                      isSelected: selectedCategory == category.name,
                      onTap: () => notifier.selectCategory(category.name),
                    );
                  },
                ),
              ),
            ),
          Expanded(
            child: switch (loaderState) {
              LoaderState.loading => const Center(child: CommonLoader()),
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
                  onPressed: () => notifier.performSearch(query: initialQuery),
                ),
              LoaderState.loaded =>
                SearchResultsContentWidget(results: results),
              _ => const SizedBox.shrink(),
            },
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: CommonContainer(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        borderRadius: 20.r,
        color: isSelected ? colors.primary : colors.surface,
        side: BorderSide(
          color: isSelected
              ? colors.primary
              : colors.cardBorder,
          width: 1.w,
        ),
        child: Center(
          child: Text(
            label,
            style: FontPalette.base500(
              13,
              color: isSelected ? ColorPalette.white : colors.primaryText,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

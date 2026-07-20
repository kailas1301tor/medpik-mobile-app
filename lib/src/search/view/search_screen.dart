// lib/src/search/view/search_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/home/notifier/home_notifier.dart';
import 'package:tsuite/src/search/model/product_catalog_args.dart';
import 'package:tsuite/src/search/notifier/search_notifier.dart';
import 'package:tsuite/src/search/view/widget/catalog_category_chips.dart';
import 'package:tsuite/utils/common_widgets/common_app_bar.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';
import 'package:tsuite/utils/common_widgets/common_search_bar.dart';
import 'package:tsuite/utils/routes/route_constants.dart';
import 'package:tuple/tuple.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_ensureHomeCategories);
  }

  void _ensureHomeCategories() {
    final home = ref.read(homeNotifierProvider);
    final categories = home.data?.categories ?? const [];
    final needsFetch = categories.isEmpty &&
        (home.loaderState == LoaderState.loading ||
            home.loaderState == LoaderState.error ||
            home.loaderState == LoaderState.networkError ||
            home.loaderState == LoaderState.serverError ||
            home.loaderState == LoaderState.noData ||
            home.data == null);
    if (needsFetch) {
      ref.read(homeNotifierProvider.notifier).fetchHomeFeed();
    }
  }

  void _openCatalog(ProductCatalogArgs args) {
    Navigator.pushNamed(
      context,
      RouteConstants.routeSearchResultsScreen,
      arguments: args,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final notifier = ref.read(searchNotifierProvider.notifier);
    final recentSearches = ref.watch(
      searchNotifierProvider.select((s) => s.recentSearches),
    );
    final homeMeta = ref.watch(
      homeNotifierProvider.select(
        (s) => Tuple2(s.loaderState, s.data?.categories.length ?? 0),
      ),
    );
    final homeLoader = homeMeta.item1;
    final categoryCount = homeMeta.item2;
    final showCategoriesSection =
        homeLoader == LoaderState.loading || categoryCount > 0;

    return CommonScaffold(
      appBar: const CommonAppBar(title: Strings.search),
      backgroundColor: colors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
            child: CommonSearchBar(
              controller: notifier.searchController,
              focusNode: notifier.searchFocusNode,
              hintText: Strings.searchMedicines,
              onChanged: notifier.onSearchChanged,
              onSubmitted: (query) {
                final trimmed = query.trim();
                if (trimmed.isEmpty) return;
                _openCatalog(
                  ProductCatalogArgs(title: trimmed, search: trimmed),
                );
              },
              onClear: notifier.clearSearch,
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(0, 24.h, 0, 24.h),
              children: [
                if (recentSearches.isNotEmpty) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      Strings.recentSearches,
                      style: FontPalette.base700(
                        16,
                        color: colors.primaryText,
                      ),
                    ),
                  ),
                  12.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: recentSearches
                          .map(
                            (query) => GestureDetector(
                              onTap: () {
                                notifier.applyRecentSearch(query);
                                _openCatalog(
                                  ProductCatalogArgs(
                                    title: query,
                                    search: query,
                                  ),
                                );
                              },
                              child: CommonContainer(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 8.h,
                                ),
                                borderRadius: 20.r,
                                color: colors.surface,
                                child: Text(
                                  query,
                                  style: FontPalette.base500(
                                    13,
                                    color: colors.primaryText,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  24.verticalSpace,
                ],
                if (showCategoriesSection) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      Strings.categories,
                      style: FontPalette.base700(
                        16,
                        color: colors.primaryText,
                      ),
                    ),
                  ),
                  12.verticalSpace,
                  CatalogCategoryChips(
                    selectedCategoryId: null,
                    onSelected: (category) {
                      if (category == null) {
                        _openCatalog(
                          const ProductCatalogArgs(
                            title: Strings.popularProducts,
                          ),
                        );
                        return;
                      }
                      _openCatalog(
                        ProductCatalogArgs(
                          title: category.name,
                          categoryId: category.id,
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

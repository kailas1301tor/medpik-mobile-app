// lib/src/search/view/search_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/data/models/category_model.dart';
import 'package:medpik/data/models/product_catalog_args.dart';
import 'package:medpik/providers/customer_general_providers.dart';
import 'package:medpik/src/search/notifier/search_notifier.dart';
import 'package:medpik/src/search/view/widget/catalog_category_chips.dart';
import 'package:medpik/src/search/view/widget/search_catalog_content_widget.dart';
import 'package:medpik/src/search/view/widget/search_landing_content_widget.dart';
import 'package:medpik/utils/common_widgets/common_app_bar.dart';
import 'package:medpik/utils/common_widgets/common_scaffold.dart';
import 'package:medpik/utils/common_widgets/common_search_bar.dart';
import 'package:tuple/tuple.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key, this.initialArgs});

  final ProductCatalogArgs? initialArgs;

  ProductCatalogArgs _catalogArgsForCategory(CategoryModel? category) {
    if (category == null) {
      return const ProductCatalogArgs(title: Strings.popularProducts);
    }
    return ProductCatalogArgs(
      title: category.name,
      categoryId: category.id,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = initialArgs;
    if (args != null) {
      ref.watch(searchCatalogInitProvider(args));
    }

    final colors = context.appColors;
    final notifier = ref.read(searchNotifierProvider.notifier);
    final screenData = ref.watch(
      searchNotifierProvider.select(
        (s) => Tuple3(s.catalogInitialized, s.catalogTitle, s.categoryId),
      ),
    );
    final catalogInitialized = screenData.item1;
    final catalogTitle = screenData.item2;
    final categoryId = screenData.item3;
    final categoryMeta = ref.watch(
      customerGeneralNotifierProvider.select(
        (s) => Tuple2(
          s.loaderState,
          s.data?.categories.length ?? 0,
        ),
      ),
    );
    final showCategoriesSection =
        categoryMeta.item1 == LoaderState.loading || categoryMeta.item2 > 0;

    return CommonScaffold(
      appBar: CommonAppBar(
        title: catalogInitialized && catalogTitle.isNotEmpty
            ? catalogTitle
            : Strings.search,
      ),
      backgroundColor: colors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
            child: CommonSearchBar(
              controller: catalogInitialized
                  ? notifier.catalogSearchController
                  : notifier.searchController,
              focusNode: catalogInitialized
                  ? notifier.catalogSearchFocusNode
                  : notifier.searchFocusNode,
              hintText: Strings.searchMedicines,
              onChanged: catalogInitialized
                  ? notifier.onCatalogSearchChanged
                  : notifier.onSearchChanged,
              onSubmitted: catalogInitialized
                  ? null
                  : (query) {
                      final trimmed = query.trim();
                      if (trimmed.isEmpty) return;
                      notifier.initCatalog(
                        ProductCatalogArgs(title: trimmed, search: trimmed),
                      );
                    },
              onClear: catalogInitialized
                  ? notifier.clearCatalogSearch
                  : notifier.clearSearch,
            ),
          ),
          if (showCategoriesSection) ...[
            if (!catalogInitialized) ...[
              16.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  Strings.categories,
                  style: FontPalette.base700(16, color: colors.primaryText),
                ),
              ),
              12.verticalSpace,
            ] else
              8.verticalSpace,
            CatalogCategoryChips(
              selectedCategoryId: catalogInitialized ? categoryId : null,
              onSelected: (category) {
                if (catalogInitialized) {
                  notifier.selectCategory(category);
                  return;
                }
                notifier.initCatalog(_catalogArgsForCategory(category));
              },
            ),
          ],
          4.verticalSpace,
          Expanded(
            child: catalogInitialized
                ? const SearchCatalogContentWidget()
                : const SearchLandingContentWidget(),
          ),
        ],
      ),
    );
  }
}

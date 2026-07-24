// lib/src/prescription/view/widget/prescription_products_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/data/models/product_model.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/prescription/notifier/prescription_products_notifier.dart';
import 'package:medpik/src/prescription/view/widget/prescription_add_missing_product_card.dart';
import 'package:medpik/src/prescription/view/widget/prescription_product_grid.dart';
import 'package:medpik/src/prescription/view/widget/prescription_products_shimmer_widget.dart';
import 'package:medpik/utils/common_widgets/common_empty_state.dart';
import 'package:medpik/utils/common_widgets/common_search_bar.dart';
import 'package:tuple/tuple.dart';

class PrescriptionProductsSection extends ConsumerWidget {
  const PrescriptionProductsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final notifier = ref.read(prescriptionProductsNotifierProvider.notifier);
    final data = ref.watch(
      prescriptionProductsNotifierProvider.select(
        (s) => Tuple4(
          s.loaderState,
          s.products,
          s.isLoadingMore,
          s.hasMore,
        ),
      ),
    );
    final searchMeta = ref.watch(
      prescriptionProductsNotifierProvider.select(
        (s) => Tuple2(s.searchQuery, s.hasSearched),
      ),
    );

    final loaderState = data.item1;
    final products = data.item2;
    final isLoadingMore = data.item3;
    final hasMore = data.item4;
    final searchQuery = searchMeta.item1;
    final hasSearched = searchMeta.item2;

    final isSearching = searchQuery.isNotEmpty;
    final showMissingProductCard = isSearching &&
        hasSearched &&
        products.isEmpty &&
        loaderState == LoaderState.noData;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          Strings.mostBoughtProducts,
          style: FontPalette.base600(14, color: colors.primaryText),
        ),
        10.verticalSpace,
        CommonSearchBar(
          controller: notifier.searchController,
          focusNode: notifier.searchFocusNode,
          hintText: Strings.searchProductsHint,
          onChanged: notifier.onSearchChanged,
          onClear: notifier.clearSearch,
        ),
        14.verticalSpace,
        _ProductsBody(
          loaderState: loaderState,
          products: products,
          showMissingProductCard: showMissingProductCard,
          searchQuery: searchQuery,
          isLoadingMore: isLoadingMore,
          hasMore: hasMore,
          onRetry: () => notifier.fetchProducts(
            page: 1,
            search: searchQuery,
          ),
          onLoadMore: notifier.loadMore,
        ),
      ],
    );
  }
}

class _ProductsBody extends StatelessWidget {
  const _ProductsBody({
    required this.loaderState,
    required this.products,
    required this.showMissingProductCard,
    required this.searchQuery,
    required this.isLoadingMore,
    required this.hasMore,
    required this.onRetry,
    required this.onLoadMore,
  });

  final LoaderState loaderState;
  final List<ProductModel> products;
  final bool showMissingProductCard;
  final String searchQuery;
  final bool isLoadingMore;
  final bool hasMore;
  final VoidCallback onRetry;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return switch (loaderState) {
      LoaderState.loading => const PrescriptionProductsShimmerWidget(),
      LoaderState.networkError ||
      LoaderState.serverError ||
      LoaderState.error =>
        CommonEmptyState(
          title: Strings.errorTitle,
          message: Strings.productsLoadFailed,
          buttonText: Strings.refresh,
          onPressed: onRetry,
          fillAvailableSpace: false,
        ),
      LoaderState.noData when showMissingProductCard =>
        PrescriptionAddMissingProductCard(query: searchQuery),
      LoaderState.noData ||
      LoaderState.noSearchData =>
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Text(
            Strings.searchProductsEmpty,
            style: FontPalette.base400(13, color: colors.secondaryText),
            textAlign: TextAlign.center,
          ),
        ),
      LoaderState.loaded => Column(
          children: [
            PrescriptionProductGrid(products: products),
            if (isLoadingMore) ...[
              12.verticalSpace,
              const PrescriptionProductsLoadMoreShimmer(),
            ] else if (hasMore && products.isNotEmpty) ...[
              8.verticalSpace,
              GestureDetector(
                onTap: onLoadMore,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
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
                        style: FontPalette.base600(14, color: colors.primary),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
    };
  }
}

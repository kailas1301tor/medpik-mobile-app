// lib/src/prescription/view/widget/prescription_products_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/prescription/notifier/prescription_products_notifier.dart';
import 'package:tsuite/src/prescription/view/widget/prescription_add_missing_product_card.dart';
import 'package:tsuite/src/prescription/view/widget/prescription_product_grid.dart';
import 'package:tsuite/utils/common_widgets/common_loader.dart';
import 'package:tsuite/utils/common_widgets/common_search_bar.dart';

class PrescriptionProductsSection extends ConsumerWidget {
  const PrescriptionProductsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final notifier = ref.read(prescriptionProductsNotifierProvider.notifier);
    final loaderState = ref.watch(
      prescriptionProductsNotifierProvider.select((s) => s.loaderState),
    );
    final searchQuery = ref.watch(
      prescriptionProductsNotifierProvider.select((s) => s.searchQuery),
    );
    final hasSearched = ref.watch(
      prescriptionProductsNotifierProvider.select((s) => s.hasSearched),
    );
    final mostBoughtProducts = ref.watch(
      prescriptionProductsNotifierProvider.select((s) => s.mostBoughtProducts),
    );
    final searchResults = ref.watch(
      prescriptionProductsNotifierProvider.select((s) => s.searchResults),
    );

    final isSearching = searchQuery.isNotEmpty;
    final showMissingProductCard =
        isSearching && hasSearched && searchResults.isEmpty &&
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
        if (loaderState == LoaderState.loading)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: const Center(child: CommonLoader()),
          )
        else if (showMissingProductCard) ...[
          PrescriptionAddMissingProductCard(query: searchQuery),
        ] else if (isSearching) ...[
          PrescriptionProductGrid(products: searchResults),
        ] else ...[
          PrescriptionProductGrid(products: mostBoughtProducts),
        ],
      ],
    );
  }
}

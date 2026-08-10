// lib/src/search/view/widget/catalog_category_chips.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/profile/customer_general_providers.dart';
import 'package:medpik/data/models/category_model.dart';
import 'package:medpik/utils/common_widgets/common_container.dart';
import 'package:medpik/utils/common_widgets/common_shimmer_box.dart';
import 'package:tuple/tuple.dart';

/// Horizontal category filter chips backed by customer general data.
class CatalogCategoryChips extends ConsumerWidget {
  const CatalogCategoryChips({
    super.key,
    required this.selectedCategoryId,
    required this.onSelected,
  });

  final int? selectedCategoryId;
  final ValueChanged<CategoryModel?> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryData = ref.watch(
      customerGeneralNotifierProvider.select(
        (s) => Tuple2(
          s.loaderState,
          s.data?.categories ?? const <CategoryModel>[],
        ),
      ),
    );
    final loaderState = categoryData.item1;
    final categories = categoryData.item2;

    if (loaderState == LoaderState.loading && categories.isEmpty) {
      return const _CategoryChipsShimmer();
    }

    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        scrollDirection: Axis.horizontal,
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: true,
        itemCount: categories.length + 1,
        separatorBuilder: (_, __) => 8.horizontalSpace,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _CatalogFilterChip(
              label: Strings.allCategories,
              isSelected: selectedCategoryId == null,
              onTap: () => onSelected(null),
            );
          }
          final category = categories[index - 1];
          return _CatalogFilterChip(
            label: category.name,
            isSelected: selectedCategoryId == category.id,
            onTap: () => onSelected(category),
          );
        },
      ),
    );
  }
}

class _CategoryChipsShimmer extends StatelessWidget {
  const _CategoryChipsShimmer();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        separatorBuilder: (_, __) => 8.horizontalSpace,
        itemBuilder: (_, index) {
          final widths = [56.w, 88.w, 72.w, 96.w, 80.w];
          return CommonShimmerBox(
            height: 32.h,
            width: widths[index % widths.length],
            borderRadius: 20.r,
          );
        },
      ),
    );
  }
}

class _CatalogFilterChip extends StatelessWidget {
  const _CatalogFilterChip({
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
          color: isSelected ? colors.primary : colors.cardBorder,
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

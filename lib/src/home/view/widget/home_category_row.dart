// lib/src/home/view/widget/home_category_row.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/medpik_image_assets.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/home/model/home_model.dart';
import 'package:medpik/utils/common_widgets/common_cached_network_image.dart';

class HomeCategoryRow extends StatelessWidget {
  const HomeCategoryRow({
    super.key,
    required this.categories,
    required this.onCategoryTap,
  });

  /// Home grid shows complete rows of this many items (4 / 8 / 12…).
  static const int crossAxisCount = 4;

  final List<CategoryModel> categories;
  final ValueChanged<CategoryModel> onCategoryTap;

  /// Largest multiple of [crossAxisCount] that fits; if fewer than one row,
  /// show whatever is available.
  static List<CategoryModel> visibleCategories(List<CategoryModel> all) {
    if (all.isEmpty) return const [];
    if (all.length < crossAxisCount) return all;
    final visibleCount = (all.length ~/ crossAxisCount) * crossAxisCount;
    return all.take(visibleCount).toList(growable: false);
  }

  static bool hasHiddenCategories(List<CategoryModel> all) =>
      all.length > visibleCategories(all).length;

  @override
  Widget build(BuildContext context) {
    final visible = visibleCategories(categories);
    if (visible.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final gap = 8.w;
          final itemWidth =
              (constraints.maxWidth - gap * (crossAxisCount - 1)) /
                  crossAxisCount;

          return Wrap(
            spacing: gap,
            runSpacing: 12.h,
            children: [
              for (final category in visible)
                SizedBox(
                  width: itemWidth,
                  child: _CategoryTile(
                    category: category,
                    onTap: () => onCategoryTap(category),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, required this.onTap});

  final CategoryModel category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final tileSize = 64.r;
    final categoryPlaceholder = CommonAssetPlaceholderImage(
      assetPath: MedpikImageAssets.categoryPlaceholder,
      width: tileSize,
      height: tileSize,
      borderRadius: tileSize / 2,
      fit: BoxFit.cover,
    );

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipOval(
            child: ColoredBox(
              // Match page background so soft PNG edges don't read as a grey ring.
              color: colors.background,
              child: CommonCachedNetworkImage(
                imageUrl: category.imageUrl,
                width: tileSize,
                height: tileSize,
                borderRadius: tileSize / 2,
                fit: BoxFit.cover,
                showBorder: false,
                errorWidget: categoryPlaceholder,
              ),
            ),
          ),
          6.verticalSpace,
          Text(
            category.name,
            style: FontPalette.base500(
              11,
              color: colors.primaryText,
            ).copyWith(height: 1.2),
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

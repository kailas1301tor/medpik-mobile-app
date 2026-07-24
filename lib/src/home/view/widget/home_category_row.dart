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

  final List<CategoryModel> categories;
  final ValueChanged<CategoryModel> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < categories.length; i++) ...[
            if (i > 0) 16.horizontalSpace,
            _CategoryTile(
              category: categories[i],
              onTap: () => onCategoryTap(categories[i]),
            ),
          ],
        ],
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
      child: SizedBox(
        width: 72.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.inputBackground,
                border: Border.all(color: colors.cardBorder),
                boxShadow: ColorPalette.productCardShadow,
              ),
              child: ClipOval(
                child: CommonCachedNetworkImage(
                  imageUrl: category.imageUrl,
                  width: tileSize,
                  height: tileSize,
                  borderRadius: tileSize / 2,
                  fit: BoxFit.cover,
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
      ),
    );
  }
}

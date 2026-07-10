// lib/src/home/view/widget/home_category_row.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/home/model/home_model.dart';
import 'package:tsuite/utils/common_widgets/common_cached_network_image.dart';

class HomeCategoryRow extends StatelessWidget {
  const HomeCategoryRow({
    super.key,
    required this.categories,
    required this.onCategoryTap,
  });

  final List<CategoryModel> categories;
  final ValueChanged<String> onCategoryTap;

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
              onTap: () => onCategoryTap(categories[i].name),
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

  IconData _iconForKey(String key) {
    return switch (key) {
      'pain' => Icons.medication_outlined,
      'vitamins' => Icons.local_pharmacy_outlined,
      'skin' => Icons.spa_outlined,
      'diabetes' => Icons.monitor_heart_outlined,
      'baby' => Icons.child_care_outlined,
      _ => Icons.category_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final tileSize = 64.r;

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
                border: Border.all(color: ColorPalette.productCardBorder),
                boxShadow: ColorPalette.productCardShadow,
              ),
              child: ClipOval(
                child: category.imageUrl.isNotEmpty
                    ? CommonCachedNetworkImage(
                        imageUrl: category.imageUrl,
                        width: tileSize,
                        height: tileSize,
                        borderRadius: tileSize / 2,
                        fit: BoxFit.cover,
                        memCacheWidth: 128,
                        memCacheHeight: 128,
                        errorWidget: _CategoryFallbackIcon(
                          icon: _iconForKey(category.iconKey),
                          size: tileSize,
                        ),
                      )
                    : _CategoryFallbackIcon(
                        icon: _iconForKey(category.iconKey),
                        size: tileSize,
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

class _CategoryFallbackIcon extends StatelessWidget {
  const _CategoryFallbackIcon({required this.icon, required this.size});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: ColorPalette.productImageBg,
      ),
      child: Icon(
        icon,
        size: 26.r,
        color: ColorPalette.productAccentTeal,
      ),
    );
  }
}

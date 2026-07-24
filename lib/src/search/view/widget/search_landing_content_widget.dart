// lib/src/search/view/widget/search_landing_content_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/data/models/product_catalog_args.dart';
import 'package:medpik/src/search/notifier/search_notifier.dart';
import 'package:medpik/utils/common_widgets/common_container.dart';

class SearchLandingContentWidget extends ConsumerWidget {
  const SearchLandingContentWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final notifier = ref.read(searchNotifierProvider.notifier);
    final recentSearches = ref.watch(
      searchNotifierProvider.select((s) => s.recentSearches),
    );

    if (recentSearches.isEmpty) {
      return const SizedBox.shrink();
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: 24.verticalSpace),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              Strings.recentSearches,
              style: FontPalette.base700(16, color: colors.primaryText),
            ),
          ),
        ),
        SliverToBoxAdapter(child: 12.verticalSpace),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: recentSearches
                  .map(
                    (query) => GestureDetector(
                      onTap: () {
                        notifier.applyRecentSearch(query);
                        notifier.initCatalog(
                          ProductCatalogArgs(title: query, search: query),
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
        ),
        SliverToBoxAdapter(child: 24.verticalSpace),
      ],
    );
  }
}

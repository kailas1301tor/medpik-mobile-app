// lib/src/search/view/search_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/search/notifier/search_notifier.dart';
import 'package:tsuite/utils/common_widgets/common_app_bar.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';
import 'package:tsuite/utils/common_widgets/common_search_bar.dart';
import 'package:tsuite/utils/routes/route_constants.dart';
import 'package:tuple/tuple.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final notifier = ref.read(searchNotifierProvider.notifier);
    final searchData = ref.watch(
      searchNotifierProvider.select(
        (s) => Tuple2(s.recentSearches, s.categories),
      ),
    );
    final recentSearches = searchData.item1;
    final categories = searchData.item2;

    return CommonScaffold(
      appBar: const CommonAppBar(title: Strings.search),
      backgroundColor: colors.background,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonSearchBar(
              controller: notifier.searchController,
              focusNode: notifier.searchFocusNode,
              hintText: Strings.searchMedicines,
              onChanged: notifier.onSearchChanged,
              onSubmitted: (query) {
                Navigator.pushNamed(
                  context,
                  RouteConstants.routeSearchResultsScreen,
                  arguments: query,
                );
              },
              onClear: notifier.clearSearch,
            ),
            24.verticalSpace,
            if (recentSearches.isNotEmpty) ...[
              Text(
                Strings.recentSearches,
                style: FontPalette.base700(16, color: colors.primaryText),
              ),
              12.verticalSpace,
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: recentSearches
                    .map(
                      (query) => GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RouteConstants.routeSearchResultsScreen,
                            arguments: query,
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
              24.verticalSpace,
            ],
            Text(
              Strings.categories,
              style: FontPalette.base700(16, color: colors.primaryText),
            ),
            12.verticalSpace,
            Expanded(
              child: ListView.separated(
                itemCount: categories.length,
                separatorBuilder: (_, __) => 8.verticalSpace,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RouteConstants.routeSearchResultsScreen,
                        arguments: category.name,
                      );
                    },
                    child: CommonContainer(
                      padding: EdgeInsets.all(16.r),
                      borderRadius: 16.r,
                      color: colors.surface,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              category.name,
                              style: FontPalette.base600(
                                15,
                                color: colors.primaryText,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: colors.secondaryText,
                            size: 20.r,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

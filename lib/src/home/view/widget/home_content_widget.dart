// lib/src/home/view/widget/home_content_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/src/home/model/home_model.dart';
import 'package:tsuite/src/home/notifier/home_notifier.dart';
import 'package:tsuite/src/home/view/widget/home_category_row.dart';
import 'package:tsuite/src/home/view/widget/home_compact_header.dart';
import 'package:tsuite/src/home/view/widget/home_hero_header.dart';
import 'package:tsuite/src/home/view/widget/home_offer_carousel.dart';
import 'package:tsuite/src/home/view/widget/home_popular_products_grid.dart';
import 'package:tsuite/src/home/view/widget/home_prescription_card.dart';
import 'package:tsuite/src/home/view/widget/home_section_header.dart';
import 'package:tsuite/utils/extensions/context_extensions.dart';
import 'package:tsuite/utils/routes/route_constants.dart';

class HomeContentWidget extends StatelessWidget {
  const HomeContentWidget({
    super.key,
    this.data,
    required this.searchController,
    required this.scrollController,
  });

  final HomeFeedModel? data;
  final TextEditingController searchController;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    void onSearchTap() {
      Navigator.pushNamed(context, RouteConstants.routeSearchScreen);
    }

    return Stack(
      children: [
        CustomScrollView(
          controller: scrollController,
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: HomeHeroHeader(
                topInset: topInset,
                greeting: data?.greeting ?? '',
                deliveryHint: data?.deliveryHint ?? '',
                searchController: searchController,
                onSearchTap: onSearchTap,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(padding: EdgeInsets.only(top: 10.h)),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
                child: HomePrescriptionCard(
                  onUploadTap: () {
                    Navigator.pushNamed(
                      context,
                      RouteConstants.routePrescriptionUploadScreen,
                    );
                  },
                ),
              ),
            ),
            if ((data?.offers ?? []).isNotEmpty) ...[
              SliverToBoxAdapter(
                child: HomeSectionHeader(title: Strings.offersForYou),
              ),
              SliverToBoxAdapter(
                child: HomeOfferCarousel(offers: data?.offers ?? []),
              ),
            ],
            SliverToBoxAdapter(
              child: HomeSectionHeader(
                title: Strings.shopByCategory,
                onSeeAll: () {
                  Navigator.pushNamed(
                    context,
                    RouteConstants.routeSearchResultsScreen,
                    arguments: Strings.allCategories,
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: HomeCategoryRow(
                categories: data?.categories ?? [],
                onCategoryTap: (name) {
                  Navigator.pushNamed(
                    context,
                    RouteConstants.routeSearchResultsScreen,
                    arguments: name,
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: HomeSectionHeader(
                title: Strings.popularProducts,
                bottomPadding: 4.h,
                onSeeAll: () {
                  Navigator.pushNamed(
                    context,
                    RouteConstants.routeSearchResultsScreen,
                    arguments: '',
                  );
                },
              ),
            ),
            HomePopularProductsGrid.sliver(
              products: data?.featuredProducts ?? [],
            ),
            SliverToBoxAdapter(child: 140.verticalSpace),
          ],
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _HomeCompactHeaderScope(
            topInset: topInset,
            deliveryHint: data?.deliveryHint ?? '',
            searchController: searchController,
            onSearchTap: onSearchTap,
          ),
        ),
      ],
    );
  }
}

class _HomeCompactHeaderScope extends ConsumerWidget {
  const _HomeCompactHeaderScope({
    required this.topInset,
    required this.deliveryHint,
    required this.searchController,
    required this.onSearchTap,
  });

  final double topInset;
  final String deliveryHint;
  final TextEditingController searchController;
  final VoidCallback onSearchTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compactProgress = ref.watch(
      homeNotifierProvider.select((s) => s.compactHeaderProgress),
    );
    final useDarkStatusIcons =
        compactProgress > 0.5 && !context.isDarkMode;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: ColorPalette.transparent,
        statusBarIconBrightness:
            useDarkStatusIcons ? Brightness.dark : Brightness.light,
        statusBarBrightness:
            useDarkStatusIcons ? Brightness.light : Brightness.dark,
      ),
      child: HomeCompactHeader(
        progress: compactProgress,
        topInset: topInset,
        deliveryHint: deliveryHint,
        searchController: searchController,
        onSearchTap: onSearchTap,
      ),
    );
  }
}

// lib/src/home/view/widget/home_content_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/src/home/model/home_model.dart';
import 'package:tsuite/src/home/notifier/home_notifier.dart';
import 'package:tsuite/src/home/view/widget/home_category_row.dart';
import 'package:tsuite/src/home/view/widget/home_compact_header.dart';
import 'package:tsuite/src/home/view/widget/home_hero_header.dart';
import 'package:tsuite/src/home/view/widget/home_offer_carousel.dart';
import 'package:tsuite/src/home/view/widget/home_popular_products_carousel.dart';
import 'package:tsuite/src/home/view/widget/home_prescription_card.dart';
import 'package:tsuite/src/home/view/widget/home_section_header.dart';
import 'package:tsuite/utils/routes/route_constants.dart';

class HomeContentWidget extends ConsumerWidget {
  const HomeContentWidget({
    super.key,
    this.data,
    required this.searchController,
  });

  final HomeFeedModel? data;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topInset = MediaQuery.paddingOf(context).top;
    final notifier = ref.read(homeNotifierProvider.notifier);
    final compactProgress = ref.watch(
      homeNotifierProvider.select((s) => s.compactHeaderProgress),
    );
    void onSearchTap() {
      Navigator.pushNamed(context, RouteConstants.routeSearchScreen);
    }

    return Stack(
      children: [
        CustomScrollView(
          controller: notifier.scrollController,
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: HomeHeroHeader(
                topInset: topInset,
                userName: data?.userName ?? '',
                deliveryHint: data?.deliveryHint ?? '',
                searchController: searchController,
                onSearchTap: onSearchTap,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
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
            SliverToBoxAdapter(
              child: HomeSectionHeader(title: Strings.offersForYou),
            ),
            SliverToBoxAdapter(
              child: HomeOfferCarousel(offers: data?.offers ?? []),
            ),
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
            SliverToBoxAdapter(
              child: HomePopularProductsCarousel(
                products: data?.featuredProducts ?? [],
              ),
            ),
            SliverToBoxAdapter(child: 140.verticalSpace),
          ],
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: HomeCompactHeader(
            progress: compactProgress,
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

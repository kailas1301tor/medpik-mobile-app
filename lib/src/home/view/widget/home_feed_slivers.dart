// lib/src/home/view/widget/home_feed_slivers.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/data/models/product_catalog_args.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/src/home/model/home_model.dart';
import 'package:medpik/src/home/view/widget/home_category_row.dart';
import 'package:medpik/src/home/view/widget/home_hero_header.dart';
import 'package:medpik/src/home/view/widget/home_offer_carousel.dart';
import 'package:medpik/src/home/view/widget/home_popular_products_grid.dart';
import 'package:medpik/src/home/view/widget/home_prescription_card.dart';
import 'package:medpik/src/home/view/widget/home_section_header.dart';
import 'package:medpik/src/home/view/widget/home_shimmer_sections.dart';
import 'package:medpik/utils/routes/route_constants.dart';

abstract final class HomeFeedSlivers {
  static List<Widget> build({
    required BuildContext context,
    required double topInset,
    required HomeFeedModel? data,
    required VoidCallback onSearchTap,
    bool isLoading = false,
  }) {
    return [
      // Only the GIF header stays constantly mounted across loading → loaded.
      SliverToBoxAdapter(
        child: HomeHeroHeader(
          topInset: topInset,
          greeting: data?.greeting ?? '',
          userName: data?.userName ?? '',
          deliveryHint: data?.deliveryHint ?? '',
          isLoading: isLoading,
          onSearchTap: onSearchTap,
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(padding: EdgeInsets.only(top: 10.h)),
      ),
      ..._bodySlivers(
        context: context,
        data: data,
        isLoading: isLoading,
      ),
    ];
  }

  /// Everything below the hero: full section shimmers while loading.
  static List<Widget> _bodySlivers({
    required BuildContext context,
    required HomeFeedModel? data,
    required bool isLoading,
  }) {
    if (isLoading) {
      return [
        const SliverToBoxAdapter(child: HomePrescriptionCardShimmer()),
        SliverToBoxAdapter(
          child: HomeSectionHeader(title: Strings.offersForYou),
        ),
        const SliverToBoxAdapter(child: HomeOfferCarouselShimmer()),
        SliverToBoxAdapter(
          child: HomeSectionHeader(title: Strings.shopByCategory),
        ),
        const SliverToBoxAdapter(child: HomeCategoryShimmerRow()),
        SliverToBoxAdapter(
          child: HomeSectionHeader(
            title: Strings.popularProducts,
            bottomPadding: 4.h,
          ),
        ),
        const SliverToBoxAdapter(child: HomeProductGridShimmer()),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 140.h + MediaQuery.viewPaddingOf(context).bottom,
          ),
        ),
      ];
    }

    final offers = data?.offers ?? const <OfferModel>[];
    final categories = data?.categories ?? const [];
    final products = data?.featuredProducts ?? const [];

    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
          child: HomePrescriptionCard(
            onUploadTap: () => _openPrescriptionUpload(context),
          ),
        ),
      ),
      if (offers.isNotEmpty) ...[
        SliverToBoxAdapter(
          child: HomeSectionHeader(title: Strings.offersForYou),
        ),
        SliverToBoxAdapter(
          child: HomeOfferCarousel(
            offers: offers,
            onOfferTap: (offer) => _openOffer(context, offer),
          ),
        ),
      ],
      SliverToBoxAdapter(
        child: HomeSectionHeader(
          title: Strings.shopByCategory,
          onSeeAll: () => _openPopularProducts(context),
        ),
      ),
      SliverToBoxAdapter(
        child: HomeCategoryRow(
          categories: categories,
          onCategoryTap: (category) => _openCategory(context, category),
        ),
      ),
      SliverToBoxAdapter(
        child: HomeSectionHeader(
          title: Strings.popularProducts,
          bottomPadding: 4.h,
          onSeeAll: () => _openPopularProducts(context),
        ),
      ),
      HomePopularProductsGrid.sliver(products: products),
      SliverToBoxAdapter(
        child: SizedBox(
          height: 140.h + MediaQuery.viewPaddingOf(context).bottom,
        ),
      ),
    ];
  }

  static void _openPrescriptionUpload(BuildContext context) {
    Navigator.pushNamed(context, RouteConstants.routePrescriptionUploadScreen);
  }

  static void _openOffer(BuildContext context, OfferModel offer) {
    Navigator.pushNamed(
      context,
      RouteConstants.routeSearchResultsScreen,
      arguments: ProductCatalogArgs(title: offer.title, offerId: offer.id),
    );
  }

  static void _openCategory(BuildContext context, CategoryModel category) {
    Navigator.pushNamed(
      context,
      RouteConstants.routeSearchResultsScreen,
      arguments: ProductCatalogArgs(
        title: category.name,
        categoryId: category.id,
      ),
    );
  }

  static void _openPopularProducts(BuildContext context) {
    Navigator.pushNamed(
      context,
      RouteConstants.routeSearchResultsScreen,
      arguments: const ProductCatalogArgs(title: Strings.popularProducts),
    );
  }
}

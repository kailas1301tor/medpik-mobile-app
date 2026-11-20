// lib/src/home/view/widget/home_feed_slivers.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/data/models/product_catalog_args.dart';
import 'package:medpik/data/models/product_model.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/src/home/model/home_model.dart';
import 'package:medpik/src/home/view/widget/home_category_row.dart';
import 'package:medpik/src/home/view/widget/home_hero_header.dart';
import 'package:medpik/src/home/view/widget/home_offer_carousel.dart';
import 'package:medpik/src/home/view/widget/home_prescription_card.dart';
import 'package:medpik/src/home/view/widget/home_product_rail.dart';
import 'package:medpik/src/home/view/widget/home_promo_banner_carousel.dart';
import 'package:medpik/src/home/view/widget/home_section_header.dart';
import 'package:medpik/src/home/view/widget/home_shimmer_sections.dart';
import 'package:medpik/utils/routes/route_constants.dart';

abstract final class HomeFeedSlivers {
  static List<Widget> build({
    required BuildContext context,
    required double topInset,
    required HomeFeedModel? data,
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
          notificationCount: data?.inAppNotificationCount ?? 0,
          isLoading: isLoading,
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
          child: HomeSectionHeader(title: Strings.shopByCategory),
        ),
        const SliverToBoxAdapter(child: HomeCategoryShimmerRow()),
        SliverToBoxAdapter(
          child: HomeSectionHeader(title: Strings.offersForYou),
        ),
        const SliverToBoxAdapter(child: HomeOfferCarouselShimmer()),
        SliverToBoxAdapter(
          child: HomeSectionHeader(
            title: Strings.popularProducts,
            bottomPadding: 4.h,
          ),
        ),
        const SliverToBoxAdapter(child: HomeProductRailShimmer()),
        SliverToBoxAdapter(
          child: HomeSectionHeader(
            title: Strings.vitaminsAndSupplements,
            bottomPadding: 4.h,
          ),
        ),
        const SliverToBoxAdapter(child: HomeProductRailShimmer()),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 140.h + MediaQuery.viewPaddingOf(context).bottom,
          ),
        ),
      ];
    }

    final categories = data?.categories ?? const [];
    final offers = data?.offers ?? const [];
    final products = data?.featuredProducts ?? const [];
    final vitamins = data?.vitaminsAndSupplements ?? const [];
    final personalCare = data?.personalCare ?? const [];
    final babyCare = data?.babyCare ?? const [];
    final bannerUrls = data?.bannerImageUrls ?? const [];

    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
          child: HomePrescriptionCard(
            supportPhone: data?.supportPhone ?? '',
            onUploadTap: () => _openPrescriptionUpload(context),
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: HomeSectionHeader(
          title: Strings.shopByCategory,
          onSeeAll: HomeCategoryRow.hasHiddenCategories(categories)
              ? () => _openAllCategories(context)
              : null,
        ),
      ),
      SliverToBoxAdapter(
        child: HomeCategoryRow(
          categories: categories,
          onCategoryTap: (category) => _openCategory(context, category),
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
      ..._productRailSlivers(
        context: context,
        title: Strings.popularProducts,
        products: products,
      ),
      ..._productRailSlivers(
        context: context,
        title: Strings.vitaminsAndSupplements,
        products: vitamins,
      ),
      ..._productRailSlivers(
        context: context,
        title: Strings.personalCare,
        products: personalCare,
      ),
      ..._productRailSlivers(
        context: context,
        title: Strings.babyCare,
        products: babyCare,
      ),
      if (bannerUrls.isNotEmpty) ...[
        SliverToBoxAdapter(
          child: HomeSectionHeader(
            title: Strings.featuredBrands,
            bottomPadding: 8.h,
          ),
        ),
        SliverToBoxAdapter(
          child: HomePromoBannerCarousel(imageUrls: bannerUrls),
        ),
      ],
      SliverToBoxAdapter(
        child: SizedBox(
          height: 140.h + MediaQuery.viewPaddingOf(context).bottom,
        ),
      ),
    ];
  }

  static List<Widget> _productRailSlivers({
    required BuildContext context,
    required String title,
    required List<ProductModel> products,
  }) {
    if (products.isEmpty) return const [];

    return [
      SliverToBoxAdapter(
        child: HomeSectionHeader(
          title: title,
          bottomPadding: 4.h,
          onSeeAll: () => _openProductCatalog(context, title: title),
        ),
      ),
      SliverToBoxAdapter(child: HomeProductRail(products: products)),
    ];
  }

  static void _openPrescriptionUpload(BuildContext context) {
    Navigator.pushNamed(context, RouteConstants.routePrescriptionUploadScreen);
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

  static void _openAllCategories(BuildContext context) {
    Navigator.pushNamed(
      context,
      RouteConstants.routeSearchResultsScreen,
      arguments: const ProductCatalogArgs(title: Strings.shopByCategory),
    );
  }

  static void _openOffer(BuildContext context, OfferModel offer) {
    Navigator.pushNamed(
      context,
      RouteConstants.routeSearchResultsScreen,
      arguments: ProductCatalogArgs(
        title: offer.title.isNotEmpty ? offer.title : Strings.offersForYou,
        offerId: offer.id > 0 ? offer.id : null,
      ),
    );
  }

  static void _openProductCatalog(
    BuildContext context, {
    required String title,
  }) {
    Navigator.pushNamed(
      context,
      RouteConstants.routeSearchResultsScreen,
      arguments: ProductCatalogArgs(title: title),
    );
  }
}

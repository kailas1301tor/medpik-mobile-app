// lib/src/home/view/widget/home_shimmer_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/src/home/view/widget/home_hero_header.dart';
import 'package:tsuite/src/home/view/widget/home_prescription_card.dart';
import 'package:tsuite/src/home/view/widget/home_section_header.dart';
import 'package:tsuite/src/home/view/widget/home_shimmer_sections.dart';
import 'package:tsuite/utils/common_widgets/common_shimmer_box.dart';
import 'package:tsuite/utils/helpers/time_of_day_greeting_helper.dart';
import 'package:tsuite/utils/routes/route_constants.dart';

class HomeShimmerWidget extends StatefulWidget {
  const HomeShimmerWidget({super.key});

  @override
  State<HomeShimmerWidget> createState() => _HomeShimmerWidgetState();
}

class _HomeShimmerWidgetState extends State<HomeShimmerWidget> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        // Same hero shell as loaded home (background image, greeting, actions).
        SliverToBoxAdapter(
          child: HomeHeroHeader(
            topInset: topInset,
            greeting: timeOfDayGreeting(),
            deliveryHint: Strings.selectDeliveryAddress,
            searchController: _searchController,
            onSearchTap: () {
              Navigator.pushNamed(context, RouteConstants.routeSearchScreen);
            },
          ),
        ),
        SliverToBoxAdapter(child: Padding(padding: EdgeInsets.only(top: 10.h))),
        // Same prescription card as loaded home (no API dependency).
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
        const SliverToBoxAdapter(
          child: HomeSectionHeader(title: Strings.offersForYou),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CommonShimmerBox(
              height: 160.h,
              width: double.infinity,
              borderRadius: 20.r,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: HomeSectionHeader(
            title: Strings.shopByCategory,
            onSeeAll: () {},
          ),
        ),
        const SliverToBoxAdapter(child: HomeCategoryShimmerRow()),
        SliverToBoxAdapter(
          child: HomeSectionHeader(
            title: Strings.popularProducts,
            bottomPadding: 4.h,
            onSeeAll: () {},
          ),
        ),
        const SliverToBoxAdapter(child: HomeProductGridShimmer()),
        SliverToBoxAdapter(child: 140.verticalSpace),
      ],
    );
  }
}

// lib/src/home/view/widget/home_shimmer_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/src/home/view/widget/home_hero_header.dart';
import 'package:medpik/src/home/view/widget/home_prescription_card.dart';
import 'package:medpik/src/home/view/widget/home_section_header.dart';
import 'package:medpik/src/home/view/widget/home_shimmer_sections.dart';
import 'package:medpik/utils/common_widgets/common_shimmer_box.dart';
import 'package:medpik/utils/helpers/time_of_day_greeting_helper.dart';
import 'package:medpik/utils/routes/route_constants.dart';

class HomeShimmerWidget extends StatelessWidget {
  const HomeShimmerWidget({super.key, required this.searchController});

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: HomeHeroHeader(
            topInset: topInset,
            greeting: timeOfDayGreeting(),
            deliveryHint: Strings.selectDeliveryAddress,
            searchController: searchController,
            onSearchTap: () {
              Navigator.pushNamed(context, RouteConstants.routeSearchScreen);
            },
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

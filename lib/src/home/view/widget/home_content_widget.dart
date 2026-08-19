// lib/src/home/view/widget/home_content_widget.dart
import 'package:flutter/material.dart';
import 'package:medpik/data/models/product_catalog_args.dart';
import 'package:medpik/src/home/model/home_model.dart';
import 'package:medpik/src/home/view/widget/home_compact_header_scope.dart';
import 'package:medpik/src/home/view/widget/home_feed_slivers.dart';
import 'package:medpik/utils/routes/route_constants.dart';

class HomeContentWidget extends StatelessWidget {
  const HomeContentWidget({
    super.key,
    this.data,
    required this.scrollController,
  });

  final HomeFeedModel? data;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    void onSearchTap() {
      Navigator.pushNamed(
        context,
        RouteConstants.routeSearchResultsScreen,
        arguments: ProductCatalogArgs.searchEntry,
      );
    }

    return Stack(
      children: [
        CustomScrollView(
          controller: scrollController,
          physics: const ClampingScrollPhysics(),
          slivers: HomeFeedSlivers.build(
            context: context,
            topInset: topInset,
            data: data,
            onSearchTap: onSearchTap,
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: HomeCompactHeaderScope(
            topInset: topInset,
            deliveryHint: data?.deliveryHint ?? '',
            onSearchTap: onSearchTap,
          ),
        ),
      ],
    );
  }
}

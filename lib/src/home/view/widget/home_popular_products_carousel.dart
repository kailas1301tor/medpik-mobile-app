// lib/src/home/view/widget/home_popular_products_carousel.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/src/home/notifier/home_notifier.dart';
import 'package:tsuite/src/home/view/widget/home_glass_product_card.dart';
import 'package:tsuite/utils/common_widgets/measure_size.dart';
import 'package:tsuite/utils/routes/route_constants.dart';

class HomePopularProductsCarousel extends ConsumerStatefulWidget {
  const HomePopularProductsCarousel({super.key, required this.products});

  final List<ProductModel> products;

  @override
  ConsumerState<HomePopularProductsCarousel> createState() =>
      _HomePopularProductsCarouselState();
}

class _HomePopularProductsCarouselState
    extends ConsumerState<HomePopularProductsCarousel> {
  double? _maxCardHeight;

  static const double _spacing = 8.0;

  void _updateMeasuredHeight(double height) {
    if (_maxCardHeight != null && height <= _maxCardHeight!) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _maxCardHeight = height);
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = widget.products;
    if (products.isEmpty) return const SizedBox.shrink();

    final pageController =
        ref.read(homeNotifierProvider.notifier).popularProductsPageController;
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final itemWidth =
        (viewportWidth * pageController.viewportFraction) - _spacing.w;

    return Stack(
      children: [
        Offstage(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: products
                  .map(
                    (product) => SizedBox(
                      width: itemWidth,
                      child: MeasureSize(
                        onChange: (size) => _updateMeasuredHeight(size.height),
                        child: HomeGlassProductCard(
                          product: product,
                          intrinsic: true,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        if (_maxCardHeight != null)
          SizedBox(
            height: _maxCardHeight,
            child: PageView.builder(
              controller: pageController,
              padEnds: false,
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 16.w : 4.w,
                    right: index == products.length - 1 ? 16.w : 4.w,
                  ),
                  child: HomeGlassProductCard(
                    product: product,
                    intrinsic: true,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RouteConstants.routeProductDetailScreen,
                        arguments: product.id,
                      );
                    },
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

// lib/src/home/view/widget/home_product_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/res/constants/app_constants.dart';
import 'package:tsuite/services/wishlist_facade_service.dart';
import 'package:tsuite/utils/common_widgets/common_glass_product_card.dart';
import 'package:tsuite/utils/routes/route_constants.dart';

class HomeProductCard extends StatelessWidget {
  const HomeProductCard({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return _HomeProductCardWishlistScope(product: product);
  }
}

class _HomeProductCardWishlistScope extends ConsumerWidget {
  const _HomeProductCardWishlistScope({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWishlisted = ref.watch(isProductWishlistedProvider(product.id));

    return CommonGlassProductCard(
      product: product,
      isWishlisted: isWishlisted,
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteConstants.routeProductDetailScreen,
          arguments: product.id,
        );
      },
      onWishlistTap: () {
        if (!AppConstants.hasSession) {
          Navigator.pushNamed(context, RouteConstants.routeLoginScreen);
          return;
        }
        ref.read(wishlistFacadeServiceProvider).toggle(product);
      },
    );
  }
}

// lib/src/home/view/widget/home_product_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medpik/data/models/product_model.dart';
import 'package:medpik/providers/wishlist_providers.dart';
import 'package:medpik/utils/common_widgets/common_glass_product_card.dart';
import 'package:medpik/utils/helpers/session_auth_helper.dart';
import 'package:medpik/utils/routes/route_constants.dart';

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
    final isWishlistLoading = ref.watch(
      isWishlistTogglePendingProvider(product.id),
    );

    return CommonGlassProductCard(
      product: product,
      isWishlisted: isWishlisted,
      isWishlistLoading: isWishlistLoading,
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteConstants.routeProductDetailScreen,
          arguments: product.id,
        );
      },
      onWishlistTap: () {
        if (!requireLogin(context)) return;
        ref.read(wishlistNotifierProvider.notifier).toggle(product);
      },
    );
  }
}

// lib/src/wishlist/view/widget/wishlist_product_card.dart
import 'package:flutter/material.dart';
import 'package:medpik/data/models/product_model.dart';
import 'package:medpik/utils/common_widgets/common_glass_product_card.dart';
import 'package:medpik/utils/routes/route_constants.dart';

class WishlistProductCard extends StatelessWidget {
  const WishlistProductCard({
    super.key,
    required this.product,
    required this.onWishlistTap,
  });

  final ProductModel product;
  final VoidCallback onWishlistTap;

  @override
  Widget build(BuildContext context) {
    return CommonGlassProductCard(
      product: product,
      isWishlisted: true,
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteConstants.routeProductDetailScreen,
          arguments: product.id,
        );
      },
      onWishlistTap: onWishlistTap,
    );
  }
}

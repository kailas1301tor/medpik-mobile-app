// lib/src/product_detail/view/widget/product_detail_quantity_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/services/cart_facade_service.dart';
import 'package:tsuite/src/product_detail/notifier/product_detail_notifier.dart';
import 'package:tsuite/src/product_detail/view/widget/product_detail_qty_stepper.dart';

/// Always-visible quantity controls under product info.
///
/// Before the item is in cart, steppers update local preview qty.
/// After add, steppers drive cart quantity.
class ProductDetailQuantitySection extends ConsumerWidget {
  const ProductDetailQuantitySection({super.key, required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final cartQuantity = ref.watch(cartProductQuantityProvider(productId));
    final localQuantity = ref.watch(
      productDetailNotifierProvider.select((s) => s.quantity),
    );
    final isInCart = cartQuantity > 0;
    final quantity = isInCart ? cartQuantity : localQuantity;
    final notifier = ref.read(productDetailNotifierProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.verticalSpace,
        Text(
          Strings.quantityLabel,
          style: FontPalette.base500(12, color: colors.secondaryText),
        ),
        10.verticalSpace,
        ProductDetailQtyStepper(
          quantity: quantity,
          allowRemoveAtOne: isInCart,
          onDecrement: notifier.decrementQuantity,
          onIncrement: notifier.incrementQuantity,
        ),
      ],
    );
  }
}

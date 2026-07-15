// lib/src/product_detail/view/widget/product_detail_sticky_footer.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/cart/notifier/cart_notifier.dart';
import 'package:tsuite/src/main/notifier/main_shell_notifier.dart';
import 'package:tsuite/src/orders/view/widget/order_sticky_bottom_bar.dart';
import 'package:tsuite/src/product_detail/notifier/product_detail_notifier.dart';
import 'package:tsuite/src/product_detail/view/widget/product_detail_qty_stepper.dart';
import 'package:tsuite/utils/common_widgets/primary_button.dart';
import 'package:tsuite/utils/extensions/context_extensions.dart';
import 'package:tsuite/utils/extensions/num_extensions.dart';

class ProductDetailStickyFooter extends ConsumerWidget {
  const ProductDetailStickyFooter({super.key});

  static const int _cartTabIndex = 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final productId = ref.watch(
      productDetailNotifierProvider.select((s) => s.detail?.product.id),
    );
    final localQuantity = ref.watch(
      productDetailNotifierProvider.select((s) => s.quantity),
    );
    final unitPrice = ref.watch(
      productDetailNotifierProvider.select((s) => s.detail?.product.price),
    );
    final cartQuantity = ref.watch(
      cartNotifierProvider.select((s) {
        if (productId == null) return 0;
        for (final item in s.items) {
          if (item.product.id == productId) return item.quantity;
        }
        return 0;
      }),
    );

    final isInCart = cartQuantity > 0;
    final quantity = isInCart ? cartQuantity : localQuantity;
    final notifier = ref.read(productDetailNotifierProvider.notifier);
    final lineTotal = (unitPrice ?? 0) * quantity;
    final ctaLabel = isInCart
        ? Strings.goToCart
        : (unitPrice != null && unitPrice > 0
            ? '${Strings.addToCart} · ${lineTotal.toCurrency(decimalDigits: 0)}'
            : Strings.addToCart);

    return OrderStickyBottomBar(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                Strings.quantityLabel,
                style: FontPalette.base500(12, color: colors.secondaryText),
              ),
              6.verticalSpace,
              SizedBox(
                height: 48.h,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ProductDetailQtyStepper(
                    quantity: quantity,
                    allowRemoveAtOne: isInCart,
                    onDecrement: notifier.decrementQuantity,
                    onIncrement: notifier.incrementQuantity,
                  ),
                ),
              ),
            ],
          ),
          16.horizontalSpace,
          Expanded(
            child: PrimaryButton(
              text: ctaLabel,
              height: 48,
              radius: 14,
              onPressed: isInCart
                  ? () => _goToCart(context, ref)
                  : notifier.addToCart,
            ),
          ),
        ],
      ),
    );
  }

  void _goToCart(BuildContext context, WidgetRef ref) {
    ref.read(mainShellNotifierProvider.notifier).setTab(_cartTabIndex);
    context.popUntilFirst();
  }
}

// lib/src/product_detail/view/widget/product_detail_sticky_footer.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/orders/view/widget/order_sticky_bottom_bar.dart';
import 'package:tsuite/src/product_detail/notifier/product_detail_notifier.dart';
import 'package:tsuite/src/product_detail/view/widget/product_detail_qty_stepper.dart';
import 'package:tsuite/utils/common_widgets/primary_button.dart';
import 'package:tsuite/utils/extensions/num_extensions.dart';

class ProductDetailStickyFooter extends ConsumerWidget {
  const ProductDetailStickyFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final quantity = ref.watch(
      productDetailNotifierProvider.select((s) => s.quantity),
    );
    final unitPrice = ref.watch(
      productDetailNotifierProvider.select((s) => s.detail?.product.price),
    );
    final notifier = ref.read(productDetailNotifierProvider.notifier);
    final lineTotal = (unitPrice ?? 0) * quantity;
    final ctaLabel = unitPrice != null && unitPrice > 0
        ? '${Strings.addToCart} · ${lineTotal.toCurrency(decimalDigits: 0)}'
        : Strings.addToCart;

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
              onPressed: notifier.addToCart,
            ),
          ),
        ],
      ),
    );
  }
}

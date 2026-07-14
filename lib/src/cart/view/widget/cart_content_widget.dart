// lib/src/cart/view/widget/cart_content_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/src/cart/notifier/cart_notifier.dart';
import 'package:tsuite/src/cart/view/widget/cart_address_card.dart';
import 'package:tsuite/src/cart/view/widget/cart_item_card.dart';
import 'package:tsuite/src/cart/view/widget/cart_medicines_header.dart';
import 'package:tsuite/src/cart/view/widget/cart_order_summary_section.dart';
import 'package:tsuite/src/cart/view/widget/cart_pharmacist_instructions_card.dart';
import 'package:tsuite/src/cart/view/widget/cart_pricing_banner.dart';
import 'package:tsuite/utils/common_widgets/common_dialog_box.dart';

class CartContentWidget extends ConsumerWidget {
  const CartContentWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartNotifierProvider.select((s) => s.items));
    final notifier = ref.read(cartNotifierProvider.notifier);
    final itemCount = notifier.totalItemCount;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CartPricingBanner(),
          20.verticalSpace,
          CartMedicinesHeader(
            itemCount: itemCount,
            onClearAll: () => _confirmClearCart(context, notifier),
          ),
          12.verticalSpace,
          for (final item in items) ...[
            CartItemCard(
              item: item,
              onIncrement: () => notifier.incrementItem(item.product.id),
              onDecrement: () => notifier.decrementItem(item.product.id),
              onRemove: () => notifier.removeItem(item.product.id),
            ),
            if (item != items.last) 12.verticalSpace,
          ],
          20.verticalSpace,
          const CartPharmacistInstructionsCard(),
          20.verticalSpace,
          const CartAddressCard(),
          20.verticalSpace,
          CartOrderSummarySection(itemCount: itemCount),
        ],
      ),
    );
  }

  void _confirmClearCart(BuildContext context, CartNotifier notifier) {
    CommonDialogBox.show(
      context: context,
      title: Strings.clearCartTitle,
      message: Strings.clearCartMessage,
      primaryLabel: Strings.clearAll,
      onPrimary: () {
        Navigator.pop(context);
        notifier.clearCart();
      },
      secondaryLabel: Strings.cancel,
      onSecondary: () => Navigator.pop(context),
    );
  }
}

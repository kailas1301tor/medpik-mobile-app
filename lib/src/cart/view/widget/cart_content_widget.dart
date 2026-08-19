// lib/src/cart/view/widget/cart_content_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/src/cart/notifier/cart_notifier.dart';
import 'package:medpik/src/cart/view/widget/cart_item_card.dart';
import 'package:medpik/src/cart/view/widget/cart_medicines_header.dart';
import 'package:medpik/utils/common_widgets/common_dialog_box.dart';

class CartContentWidget extends ConsumerWidget {
  const CartContentWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartNotifierProvider.select((s) => s.items));
    final itemCount = items.fold<int>(0, (sum, item) => sum + item.quantity);
    final notifier = ref.read(cartNotifierProvider.notifier);

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              CartMedicinesHeader(
                itemCount: itemCount,
                onClearAll: () => _confirmClearCart(context, notifier),
              ),
              8.verticalSpace,
            ]),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
          sliver: SliverList.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return CartItemCard(
                item: item,
                showDivider: index < items.length - 1,
                onIncrement: () => notifier.incrementItem(item.product.id),
                onDecrement: () => notifier.decrementItem(item.product.id),
                onRemove: () => notifier.removeCartLine(item.id),
              );
            },
          ),
        ),
      ],
    );
  }

  void _confirmClearCart(BuildContext context, CartNotifier notifier) {
    CommonDialogBox.show(
      context: context,
      title: Strings.clearCartTitle,
      message: Strings.clearCartMessage,
      primaryLabel: Strings.clearAll,
      onPrimaryAsync: () async {
        await notifier.clearCart();
        return true;
      },
      secondaryLabel: Strings.cancel,
    );
  }
}

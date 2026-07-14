// lib/src/cart/view/widget/cart_submit_footer.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/src/cart/notifier/cart_notifier.dart';
import 'package:tsuite/src/orders/view/widget/order_sticky_bottom_bar.dart';
import 'package:tsuite/utils/common_widgets/primary_button.dart';

class CartSubmitFooter extends ConsumerWidget {
  const CartSubmitFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loaderState = ref.watch(
      cartNotifierProvider.select((s) => s.loaderState),
    );
    final notifier = ref.read(cartNotifierProvider.notifier);
    final isLoading = loaderState == LoaderState.loading;

    return OrderStickyBottomBar(
      child: PrimaryButton(
        text: Strings.submitOrder,
        isLoading: isLoading,
        onPressed: isLoading ? null : notifier.submitOrder,
      ),
    );
  }
}

// lib/src/cart/view/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuite/res/constants/assets.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/src/cart/notifier/cart_notifier.dart';
import 'package:tsuite/src/cart/view/widget/cart_content_widget.dart';
import 'package:tsuite/src/cart/view/widget/cart_screen_header.dart';
import 'package:tsuite/src/cart/view/widget/cart_submit_footer.dart';
import 'package:tsuite/src/cart/view/widget/cart_success_content.dart';
import 'package:tsuite/utils/common_widgets/common_switch_state.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final submittedOrderId = ref.watch(
      cartNotifierProvider.select((s) => s.submittedOrderId),
    );
    final items = ref.watch(cartNotifierProvider.select((s) => s.items));

    final loaderState = submittedOrderId == null && items.isEmpty
        ? LoaderState.noData
        : LoaderState.loaded;

    return Column(
      children: [
        const CartScreenHeader(),
        Expanded(
          child: CommonSwitchState(
            loaderState: loaderState,
            buttonText: Strings.letsGetStarted,
            reload: () {},
            emptyScreenTitle: Strings.cartTitle,
            emptyScreenDescription: Strings.cartEmptyMessage,
            emptyScreenImage: Assets.lottieEmptyCart,
            child: submittedOrderId != null
                ? const CartSuccessContent()
                : const Column(
                    children: [
                      Expanded(child: CartContentWidget()),
                      CartSubmitFooter(),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

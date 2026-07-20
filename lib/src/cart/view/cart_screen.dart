// lib/src/cart/view/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuite/res/constants/assets.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/src/cart/notifier/cart_notifier.dart';
import 'package:tsuite/src/cart/view/widget/cart_content_widget.dart';
import 'package:tsuite/src/cart/view/widget/cart_screen_header.dart';
import 'package:tsuite/src/cart/view/widget/cart_shimmer_widget.dart';
import 'package:tsuite/src/cart/view/widget/cart_submit_footer.dart';
import 'package:tsuite/src/main/notifier/main_shell_notifier.dart';
import 'package:tsuite/utils/common_widgets/common_empty_state.dart';
import 'package:tsuite/utils/common_widgets/common_refresh_indicator.dart';
import 'package:tsuite/utils/common_widgets/common_switch_state.dart';
import 'package:tuple/tuple.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenData = ref.watch(
      cartNotifierProvider.select(
        (s) => Tuple2(s.loaderState, s.items.isNotEmpty),
      ),
    );
    final loaderState = screenData.item1;
    final hasItems = screenData.item2;
    final showCheckoutFooter =
        loaderState == LoaderState.loaded && hasItems;

    return Column(
      children: [
        const CartScreenHeader(),
        Expanded(
          child: CommonRefreshIndicator(
            onRefresh: () =>
                ref.read(cartNotifierProvider.notifier).fetchCart(),
            child: CommonSwitchState(
              loaderState: loaderState,
              loader: const CartShimmerWidget(),
              buttonText: Strings.refresh,
              reload: () => ref.read(cartNotifierProvider.notifier).fetchCart(),
              emptyScreenTitle: Strings.cartTitle,
              emptyScreenDescription: Strings.cartEmptyMessage,
              emptyScreenImage: Assets.lottieEmptyCart,
              noData: CommonEmptyState(
                title: Strings.cartTitle,
                message: Strings.cartEmptyMessage,
                imageAsset: Assets.lottieEmptyCart,
                buttonText: Strings.startShopping,
                onPressed: () =>
                    ref.read(mainShellNotifierProvider.notifier).setTab(0),
              ),
              child: const CartContentWidget(),
            ),
          ),
        ),
        if (showCheckoutFooter) const CartSubmitFooter(),
      ],
    );
  }
}

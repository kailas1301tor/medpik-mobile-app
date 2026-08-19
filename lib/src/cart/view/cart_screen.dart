// lib/src/cart/view/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medpik/providers/shell_providers.dart';
import 'package:medpik/res/constants/assets.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/src/cart/notifier/cart_notifier.dart';
import 'package:medpik/src/cart/view/widget/cart_content_widget.dart';
import 'package:medpik/src/cart/view/widget/cart_shimmer_widget.dart';
import 'package:medpik/src/cart/view/widget/cart_submit_footer.dart';
import 'package:medpik/utils/common_widgets/cart_mutation_overlay.dart';
import 'package:medpik/utils/common_widgets/common_empty_state.dart';
import 'package:medpik/utils/common_widgets/common_refresh_indicator.dart';
import 'package:medpik/utils/common_widgets/common_switch_state.dart';
import 'package:medpik/utils/common_widgets/shell_tab_header.dart';
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
    final showCheckoutFooter = loaderState == LoaderState.loaded && hasItems;
    final notifier = ref.read(cartNotifierProvider.notifier);

    return CartMutationOverlay(
      child: Column(
        children: [
          const ShellTabHeader(title: Strings.cartTitle),
          Expanded(
            child: CommonRefreshIndicator(
              onRefresh: () => notifier.fetchCart(showLoader: false),
              child: CommonSwitchState(
                loaderState: loaderState,
                loader: const CartShimmerWidget(),
                buttonText: Strings.refresh,
                reload: () => notifier.fetchCart(showLoader: true),
                emptyScreenTitle: Strings.cartTitle,
                emptyScreenDescription: Strings.cartEmptyMessage,
                emptyScreenImage: Assets.pngNoData,
                noData: CommonEmptyState(
                  title: Strings.cartTitle,
                  message: Strings.cartEmptyMessage,
                  imageAsset: Assets.pngNoData,
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
      ),
    );
  }
}

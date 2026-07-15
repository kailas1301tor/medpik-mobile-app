// lib/src/orders/view/orders_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuite/res/constants/assets.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/src/orders/notifier/orders_notifier.dart';
import 'package:tsuite/src/orders/view/widget/orders_content_widget.dart';
import 'package:tsuite/utils/common_widgets/common_refresh_indicator.dart';
import 'package:tsuite/utils/common_widgets/common_switch_state.dart';

import 'widget/orders_screen_header.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loaderState = ref.watch(
      ordersNotifierProvider.select((s) => s.loaderState),
    );
    final orders = ref.watch(ordersNotifierProvider.select((s) => s.orders));

    return CommonRefreshIndicator(
      onRefresh: () => ref.read(ordersNotifierProvider.notifier).fetchOrders(),
      child: Column(
        children: [
          const OrdersScreenHeader(),
          Expanded(
            child: CommonSwitchState(
              loaderState: loaderState,
              reload: () =>
                  ref.read(ordersNotifierProvider.notifier).fetchOrders(),
              buttonText: Strings.refresh,
              emptyScreenTitle: Strings.noOrdersYet,
              emptyScreenDescription: Strings.noOrdersMessage,
              emptyScreenImage: Assets.lottieEmptyOrder,
              child: OrdersContentWidget(orders: orders),
            ),
          ),
        ],
      ),
    );
  }
}

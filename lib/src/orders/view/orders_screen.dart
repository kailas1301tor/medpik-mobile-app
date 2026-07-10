// lib/src/orders/view/orders_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/orders/notifier/orders_notifier.dart';
import 'package:tsuite/src/orders/view/widget/order_tile.dart';
import 'package:tsuite/utils/common_widgets/common_empty_state.dart';
import 'package:tsuite/utils/common_widgets/common_loader.dart';
import 'package:tsuite/utils/common_widgets/common_refresh_indicator.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';
import 'package:tsuite/utils/routes/route_constants.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final loaderState = ref.watch(
      ordersNotifierProvider.select((s) => s.loaderState),
    );
    final activeOrders = ref.watch(
      ordersNotifierProvider.select((s) => s.activeOrders),
    );
    final pastOrders = ref.watch(
      ordersNotifierProvider.select((s) => s.pastOrders),
    );

    return CommonScaffold(
      backgroundColor: colors.background,
      body: switch (loaderState) {
        LoaderState.loading => const Center(child: CommonLoader()),
        LoaderState.noData => CommonEmptyState(
            title: Strings.noOrdersYet,
            message: Strings.noOrdersMessage,
            buttonText: Strings.continueShopping,
            onPressed: () {},
          ),
        LoaderState.error ||
        LoaderState.networkError ||
        LoaderState.serverError ||
        LoaderState.noSearchData =>
          CommonEmptyState(
            title: Strings.errorTitle,
            message: Strings.somethingWentWrong,
            buttonText: Strings.refresh,
            onPressed: () =>
                ref.read(ordersNotifierProvider.notifier).fetchOrders(),
          ),
        LoaderState.loaded => CommonRefreshIndicator(
            onRefresh: () =>
                ref.read(ordersNotifierProvider.notifier).fetchOrders(),
            child: ListView(
              padding: EdgeInsets.all(20.r),
              children: [
                if (activeOrders.isNotEmpty) ...[
                  Text(
                    Strings.activeOrders,
                    style: FontPalette.base700(18, color: colors.primaryText),
                  ),
                  12.verticalSpace,
                  ...activeOrders.map(
                    (order) => OrderTile(
                      order: order,
                      onTap: () => Navigator.pushNamed(
                        context,
                        RouteConstants.routeOrderDetailScreen,
                        arguments: order.id,
                      ),
                    ),
                  ),
                  24.verticalSpace,
                ],
                if (pastOrders.isNotEmpty) ...[
                  Text(
                    Strings.pastOrders,
                    style: FontPalette.base700(18, color: colors.primaryText),
                  ),
                  12.verticalSpace,
                  ...pastOrders.map(
                    (order) => OrderTile(
                      order: order,
                      onTap: () => Navigator.pushNamed(
                        context,
                        RouteConstants.routeOrderDetailScreen,
                        arguments: order.id,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
      },
    );
  }
}

// lib/src/orders/view/order_review_bill_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/src/orders/notifier/orders_notifier.dart';
import 'package:medpik/src/orders/view/widget/order_reject_bill_sheet.dart';
import 'package:medpik/src/orders/view/widget/order_review_bill_actions.dart';
import 'package:medpik/src/orders/view/widget/order_review_bill_content_widget.dart';
import 'package:medpik/src/orders/view/widget/order_support_app_bar.dart';
import 'package:medpik/src/orders/view/widget/order_detail_shimmer_widget.dart';
import 'package:medpik/utils/common_widgets/common_scaffold.dart';
import 'package:medpik/utils/common_widgets/common_switch_state.dart';
import 'package:medpik/utils/routes/route_constants.dart';
import 'package:tuple/tuple.dart';

class OrderReviewBillScreen extends ConsumerWidget {
  const OrderReviewBillScreen({super.key, required this.orderId});

  final String orderId;

  Future<void> _onAccept(BuildContext context, WidgetRef ref) async {
    final success =
        await ref.read(ordersNotifierProvider.notifier).acceptBill(orderId);
    if (!context.mounted || !success) return;

    Navigator.pushReplacementNamed(
      context,
      RouteConstants.routeOrderReviewPayScreen,
      arguments: orderId,
    );
  }

  Future<void> _onReject(BuildContext context, WidgetRef ref) async {
    final success = await OrderRejectBillSheet.show(
      context: context,
      ref: ref,
      orderId: orderId,
    );
    if (!context.mounted || !success) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(orderDetailLoaderProvider(orderId));

    final colors = context.appColors;
    final orderData = ref.watch(
      ordersNotifierProvider.select(
        (s) => Tuple4(
          s.detailLoaderState,
          s.selectedOrder,
          s.isAcceptBillLoading,
          s.isRejectBillLoading,
        ),
      ),
    );
    final detailLoaderState = orderData.item1;
    final order = orderData.item2;
    final isAcceptBillLoading = orderData.item3;
    final isRejectBillLoading = orderData.item4;
    final isBillActionLoading = isAcceptBillLoading || isRejectBillLoading;
    final notifier = ref.read(ordersNotifierProvider.notifier);

    return CommonScaffold(
      appBar: const OrderSupportAppBar(title: Strings.reviewOrderAndBill),
      backgroundColor: colors.background,
      safeAreaBottom: false,
      body: CommonSwitchState(
        loaderState: detailLoaderState,
        reload: () => notifier.loadOrderDetail(orderId),
        buttonText: Strings.refresh,
        loader: const OrderDetailShimmerWidget(),
        child: order == null
            ? const SizedBox.shrink()
            : Column(
                children: [
                  Expanded(
                    child: OrderReviewBillContentWidget(order: order),
                  ),
                  IgnorePointer(
                    ignoring: isBillActionLoading,
                    child: OrderReviewBillActions(
                      isAcceptLoading: isAcceptBillLoading,
                      isRejectLoading: isRejectBillLoading,
                      onReject: () => _onReject(context, ref),
                      onAccept: () => _onAccept(context, ref),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

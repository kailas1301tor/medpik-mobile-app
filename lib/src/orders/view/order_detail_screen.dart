// lib/src/orders/view/order_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/src/orders/notifier/orders_notifier.dart';
import 'package:tsuite/src/orders/view/widget/order_detail_bottom_bar.dart';
import 'package:tsuite/src/orders/view/widget/order_detail_content_widget.dart';
import 'package:tsuite/src/orders/view/widget/order_support_app_bar.dart';
import 'package:tsuite/src/orders/view/widget/order_detail_shimmer_widget.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';
import 'package:tsuite/utils/common_widgets/common_switch_state.dart';
import 'package:tsuite/utils/helpers/order_status_helper.dart';
import 'package:tsuite/utils/routes/route_constants.dart';
import 'package:tuple/tuple.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref
          .read(ordersNotifierProvider.notifier)
          .loadOrderDetail(widget.orderId),
    );
  }

  void _onCtaPressed(OrderDetailCtaAction action) {
    switch (action) {
      case OrderDetailCtaAction.reviewBill:
        Navigator.pushNamed(
          context,
          RouteConstants.routeOrderReviewBillScreen,
          arguments: widget.orderId,
        );
      case OrderDetailCtaAction.reviewPay:
        Navigator.pushNamed(
          context,
          RouteConstants.routeOrderReviewPayScreen,
          arguments: widget.orderId,
        );
      case OrderDetailCtaAction.trackOrder:
        Navigator.pushNamed(
          context,
          RouteConstants.routeTrackingScreen,
          arguments: widget.orderId,
        );
      case OrderDetailCtaAction.uploadPrescription:
        Navigator.pushNamed(
          context,
          RouteConstants.routePrescriptionUploadScreen,
        );
      case OrderDetailCtaAction.none:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final orderData = ref.watch(
      ordersNotifierProvider.select(
        (s) => Tuple2(s.detailLoaderState, s.selectedOrder),
      ),
    );
    final detailLoaderState = orderData.item1;
    final order = orderData.item2;
    final cta = order == null ? null : orderDetailPrimaryCta(order.status);

    return CommonScaffold(
      appBar: const OrderSupportAppBar(title: Strings.orderDetails),
      backgroundColor: colors.background,
      safeAreaBottom: false,
      body: CommonSwitchState(
        loaderState: detailLoaderState,
        reload: () => ref
            .read(ordersNotifierProvider.notifier)
            .loadOrderDetail(widget.orderId),
        buttonText: Strings.refresh,
        loader: const OrderDetailShimmerWidget(),
        child: order == null
            ? const SizedBox.shrink()
            : Column(
                children: [
                  Expanded(
                    child: OrderDetailContentWidget(
                      order: order,
                      onBannerTap: orderDetailShowsBillCard(order.status)
                          ? () => _onCtaPressed(
                                OrderDetailCtaAction.reviewBill,
                              )
                          : null,
                    ),
                  ),
                  if (cta != null)
                    OrderDetailBottomBar(
                      order: order,
                      onCtaPressed: () => _onCtaPressed(cta.action),
                    ),
                ],
              ),
      ),
    );
  }
}

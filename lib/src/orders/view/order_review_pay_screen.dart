// lib/src/orders/view/order_review_pay_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/src/orders/notifier/orders_notifier.dart';
import 'package:tsuite/src/orders/view/widget/order_review_pay_content_widget.dart';
import 'package:tsuite/src/orders/view/widget/order_support_app_bar.dart';
import 'package:tsuite/utils/common_widgets/common_loader.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';
import 'package:tsuite/utils/common_widgets/common_switch_state.dart';
import 'package:tsuite/utils/common_widgets/common_sticky_bottom_bar.dart';
import 'package:tsuite/utils/common_widgets/primary_button.dart';
import 'package:tsuite/utils/extensions/num_extensions.dart';
import 'package:tsuite/utils/routes/route_constants.dart';
import 'package:tuple/tuple.dart';

class OrderReviewPayScreen extends ConsumerStatefulWidget {
  const OrderReviewPayScreen({super.key, required this.orderId});

  final String orderId;

  @override
  ConsumerState<OrderReviewPayScreen> createState() =>
      _OrderReviewPayScreenState();
}

class _OrderReviewPayScreenState extends ConsumerState<OrderReviewPayScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref
          .read(ordersNotifierProvider.notifier)
          .loadOrderDetail(widget.orderId),
    );
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
    final notifier = ref.read(ordersNotifierProvider.notifier);

    return CommonScaffold(
      appBar: const OrderSupportAppBar(title: Strings.reviewAndPay),
      backgroundColor: colors.background,
      safeAreaBottom: false,
      body: CommonSwitchState(
        loaderState: detailLoaderState,
        reload: () => notifier.loadOrderDetail(widget.orderId),
        buttonText: Strings.refresh,
        loader: const Center(child: CommonLoader()),
        child: order == null
            ? const SizedBox.shrink()
            : Column(
                children: [
                  Expanded(
                    child: OrderReviewPayContentWidget(order: order),
                  ),
                  CommonStickyBottomBar(
                    child: PrimaryButton(
                      text: Strings.payNowWithAmount(
                        order.displayGrandTotal.toCurrency(decimalDigits: 0),
                      ),
                      height: 52.h,
                      prefixIcon: Icon(
                        Icons.lock_outline_rounded,
                        size: 18.r,
                        color: ColorPalette.white,
                      ),
                      onPressed: () {
                        notifier.payOrder();
                        Navigator.popUntil(
                          context,
                          (route) =>
                              route.settings.name ==
                                  RouteConstants.routeOrderDetailScreen ||
                              route.isFirst,
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

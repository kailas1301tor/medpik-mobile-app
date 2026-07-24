// lib/src/orders/view/order_review_pay_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/src/orders/model/order_payment_outcome.dart';
import 'package:medpik/src/orders/model/order_payment_result_args.dart';
import 'package:medpik/src/orders/notifier/orders_notifier.dart';
import 'package:medpik/src/orders/view/widget/order_review_pay_content_widget.dart';
import 'package:medpik/src/orders/view/widget/order_support_app_bar.dart';
import 'package:medpik/src/orders/view/widget/order_detail_shimmer_widget.dart';
import 'package:medpik/utils/common_widgets/common_scaffold.dart';
import 'package:medpik/utils/common_widgets/common_switch_state.dart';
import 'package:medpik/utils/common_widgets/common_sticky_bottom_bar.dart';
import 'package:medpik/utils/common_widgets/primary_button.dart';
import 'package:medpik/utils/extensions/num_extensions.dart';
import 'package:medpik/utils/routes/route_constants.dart';
import 'package:tuple/tuple.dart';

class OrderReviewPayScreen extends ConsumerWidget {
  const OrderReviewPayScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(orderDetailLoaderProvider(orderId));

    final colors = context.appColors;
    final orderData = ref.watch(
      ordersNotifierProvider.select(
        (s) => Tuple3(
          s.detailLoaderState,
          s.selectedOrder,
          Tuple2(s.selectedPaymentMethod, s.isPaymentLoading),
        ),
      ),
    );
    final detailLoaderState = orderData.item1;
    final order = orderData.item2;
    final selectedPaymentMethod = orderData.item3.item1;
    final isPaymentLoading = orderData.item3.item2;
    final notifier = ref.read(ordersNotifierProvider.notifier);

    return PopScope(
      canPop: !isPaymentLoading,
      child: CommonScaffold(
        appBar: const OrderSupportAppBar(title: Strings.reviewAndPay),
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
                      child: OrderReviewPayContentWidget(order: order),
                    ),
                    CommonStickyBottomBar(
                      child: PrimaryButton(
                        text: selectedPaymentMethod ==
                                OrderPaymentMethod.cashOnDelivery
                            ? Strings.placeOrder
                            : Strings.payNowWithAmount(
                                order.displayGrandTotal
                                    .toCurrency(decimalDigits: 0),
                              ),
                        height: 52.h,
                        isLoading: isPaymentLoading,
                        prefixIcon: Icon(
                          Icons.lock_outline_rounded,
                          size: 18.r,
                          color: ColorPalette.white,
                        ),
                        onPressed: isPaymentLoading
                            ? null
                            : () => _onPayPressed(
                                  context,
                                  notifier,
                                ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _onPayPressed(
    BuildContext context,
    OrdersNotifier notifier,
  ) async {
    final result = await notifier.payOrder(orderId: orderId);
    if (!context.mounted) return;

    switch (result.outcome) {
      case OrderPaymentOutcome.success:
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteConstants.routeOrderPaymentSuccessScreen,
          (route) => route.settings.name == RouteConstants.mainScreen,
          arguments: OrderPaymentResultArgs(orderId: orderId),
        );
      case OrderPaymentOutcome.failure:
      case OrderPaymentOutcome.cancelled:
        Navigator.pushReplacementNamed(
          context,
          RouteConstants.routeOrderPaymentFailureScreen,
          arguments: OrderPaymentResultArgs(
            orderId: orderId,
            outcome: result.outcome,
            message: result.message,
          ),
        );
    }
  }
}

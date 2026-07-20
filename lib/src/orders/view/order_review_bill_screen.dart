// lib/src/orders/view/order_review_bill_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/src/orders/notifier/orders_notifier.dart';
import 'package:tsuite/src/orders/view/widget/order_review_bill_content_widget.dart';
import 'package:tsuite/src/orders/view/widget/order_support_app_bar.dart';
import 'package:tsuite/utils/common_widgets/common_loader.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';
import 'package:tsuite/utils/common_widgets/common_switch_state.dart';
import 'package:tsuite/utils/common_widgets/common_sticky_bottom_bar.dart';
import 'package:tsuite/utils/common_widgets/primary_button.dart';
import 'package:tsuite/utils/routes/route_constants.dart';
import 'package:tuple/tuple.dart';

class OrderReviewBillScreen extends ConsumerStatefulWidget {
  const OrderReviewBillScreen({super.key, required this.orderId});

  final String orderId;

  @override
  ConsumerState<OrderReviewBillScreen> createState() =>
      _OrderReviewBillScreenState();
}

class _OrderReviewBillScreenState extends ConsumerState<OrderReviewBillScreen> {
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
      appBar: const OrderSupportAppBar(title: Strings.reviewOrderAndBill),
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
                    child: OrderReviewBillContentWidget(order: order),
                  ),
                  _ReviewBillActions(
                    onReject: () {
                      notifier.rejectBill();
                      Navigator.pop(context);
                    },
                    onAccept: () {
                      notifier.acceptBill();
                      Navigator.pushReplacementNamed(
                        context,
                        RouteConstants.routeOrderReviewPayScreen,
                        arguments: widget.orderId,
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}

class _ReviewBillActions extends StatelessWidget {
  const _ReviewBillActions({
    required this.onReject,
    required this.onAccept,
  });

  final VoidCallback onReject;
  final VoidCallback onAccept;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return CommonStickyBottomBar(
      child: Row(
        children: [
          Expanded(
            child: PrimaryButton(
              text: Strings.rejectBill,
              height: 48.h,
              backgroundColor: colors.surface,
              textColor: ColorPalette.orderRejectButtonBorder,
              borderSide: BorderSide(
                color: ColorPalette.orderRejectButtonBorder,
                width: 1.5.w,
              ),
              onPressed: onReject,
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: PrimaryButton(
              text: Strings.acceptBill,
              height: 48.h,
              onPressed: onAccept,
            ),
          ),
        ],
      ),
    );
  }
}

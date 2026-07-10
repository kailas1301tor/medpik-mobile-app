// lib/src/orders/view/order_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/orders/notifier/orders_notifier.dart';
import 'package:tsuite/utils/common_widgets/common_app_bar.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';
import 'package:tsuite/utils/common_widgets/common_loader.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';
import 'package:tsuite/utils/common_widgets/primary_button.dart';
import 'package:tsuite/utils/helpers/order_status_helper.dart';
import 'package:tsuite/utils/routes/route_constants.dart';

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

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final loaderState = ref.watch(
      ordersNotifierProvider.select((s) => s.loaderState),
    );
    final order = ref.watch(
      ordersNotifierProvider.select((s) => s.selectedOrder),
    );

    if (loaderState == LoaderState.loading || order == null) {
      return CommonScaffold(
        appBar: const CommonAppBar(title: Strings.orderDetails),
        body: const Center(child: CommonLoader()),
      );
    }

    return CommonScaffold(
      appBar: const CommonAppBar(title: Strings.orderDetails),
      backgroundColor: colors.background,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20.r),
              children: [
                CommonContainer(
                  padding: EdgeInsets.all(16.r),
                  borderRadius: 16.r,
                  color: colors.surface,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${Strings.orderIdLabel}: ${order.id}',
                        style: FontPalette.base700(16, color: colors.primaryText),
                      ),
                      8.verticalSpace,
                      Text(
                        orderStatusLabel(order.status),
                        style: FontPalette.base600(14, color: colors.primary),
                      ),
                      if (order.etaText?.isNotEmpty ?? false) ...[
                        8.verticalSpace,
                        Text(
                          order.etaText!,
                          style: FontPalette.base400(
                            13,
                            color: colors.secondaryText,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                16.verticalSpace,
                Text(
                  Strings.deliveryAddress,
                  style: FontPalette.base700(16, color: colors.primaryText),
                ),
                8.verticalSpace,
                CommonContainer(
                  padding: EdgeInsets.all(16.r),
                  borderRadius: 16.r,
                  color: colors.surface,
                  child: Text(
                    order.address.fullAddress,
                    style: FontPalette.base400(14, color: colors.secondaryText),
                  ),
                ),
                16.verticalSpace,
                Text(
                  Strings.orderSummary,
                  style: FontPalette.base700(16, color: colors.primaryText),
                ),
                8.verticalSpace,
                ...order.items.map(
                  (item) => CommonContainer(
                    margin: EdgeInsets.only(bottom: 8.h),
                    padding: EdgeInsets.all(12.r),
                    borderRadius: 12.r,
                    color: colors.surface,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.product.name,
                            style: FontPalette.base500(
                              14,
                              color: colors.primaryText,
                            ),
                          ),
                        ),
                        Text(
                          'x${item.quantity}',
                          style: FontPalette.base400(
                            13,
                            color: colors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                16.verticalSpace,
              ],
            ),
          ),
          if (order.isActive)
            Padding(
              padding: EdgeInsets.all(20.r),
              child: SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: Strings.trackOrder,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      RouteConstants.routeTrackingScreen,
                      arguments: order.id,
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

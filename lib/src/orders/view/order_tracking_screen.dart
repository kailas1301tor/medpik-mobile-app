// lib/src/orders/view/order_tracking_screen.dart
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
import 'package:tsuite/utils/helpers/order_status_helper.dart';

class OrderTrackingScreen extends ConsumerStatefulWidget {
  const OrderTrackingScreen({super.key, required this.orderId});

  final String orderId;

  @override
  ConsumerState<OrderTrackingScreen> createState() =>
      _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends ConsumerState<OrderTrackingScreen> {
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
        appBar: const CommonAppBar(title: Strings.trackOrder),
        body: const Center(child: CommonLoader()),
      );
    }

    final steps = orderTrackingSteps(order.status);

    return CommonScaffold(
      appBar: const CommonAppBar(title: Strings.trackOrder),
      backgroundColor: colors.background,
      body: ListView(
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
                if (order.etaText?.isNotEmpty ?? false)
                  Text(
                    order.etaText!,
                    style: FontPalette.base500(14, color: colors.primary),
                  ),
              ],
            ),
          ),
          24.verticalSpace,
          ...steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isDone = step.isCompleted;
            final isLast = index == steps.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 24.r,
                      height: 24.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDone ? colors.primary : colors.inputBorder,
                      ),
                      child: isDone
                          ? Icon(Icons.check, size: 14.r, color: ColorPalette.white)
                          : null,
                    ),
                    if (!isLast)
                      Container(
                        width: 2.w,
                        height: 40.h,
                        color: isDone ? colors.primary : colors.inputBorder,
                      ),
                  ],
                ),
                12.horizontalSpace,
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 24.h),
                    child: Text(
                      step.label,
                      style: FontPalette.base500(
                        14,
                        color: isDone
                            ? colors.primaryText
                            : colors.secondaryText,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

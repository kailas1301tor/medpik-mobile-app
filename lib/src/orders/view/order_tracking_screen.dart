// lib/src/orders/view/order_tracking_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medpik/data/models/order_model.dart';
import 'package:medpik/res/constants/medpik_svg_assets.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/providers/order_status_options_provider.dart';
import 'package:medpik/src/orders/notifier/orders_notifier.dart';
import 'package:medpik/src/orders/view/widget/order_detail_section_card.dart';
import 'package:medpik/src/orders/view/widget/order_tracking_step_tile.dart';
import 'package:medpik/utils/common_widgets/common_app_bar.dart';
import 'package:medpik/src/orders/view/widget/order_detail_shimmer_widget.dart';
import 'package:medpik/utils/common_widgets/common_scaffold.dart';
import 'package:medpik/utils/common_widgets/common_switch_state.dart';
import 'package:medpik/utils/helpers/order_status_helper.dart';
import 'package:tuple/tuple.dart';

class OrderTrackingScreen extends ConsumerWidget {
  const OrderTrackingScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(orderDetailLoaderProvider(orderId));

    final colors = context.appColors;
    final orderData = ref.watch(
      ordersNotifierProvider.select(
        (s) => Tuple2(s.detailLoaderState, s.selectedOrder),
      ),
    );
    final loaderState = orderData.item1;
    final order = orderData.item2;

    return CommonScaffold(
      appBar: const CommonAppBar(title: Strings.trackOrder),
      backgroundColor: colors.background,
      body: CommonSwitchState(
        loaderState: loaderState,
        reload: () =>
            ref.read(ordersNotifierProvider.notifier).loadOrderDetail(orderId),
        buttonText: Strings.refresh,
        loader: const OrderDetailShimmerWidget(),
        child: order == null
            ? const SizedBox.shrink()
            : _OrderTrackingBody(order: order),
      ),
    );
  }
}

class _OrderTrackingBody extends ConsumerWidget {
  const _OrderTrackingBody({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final statusOptions = ref.watch(
      orderStatusOptionsProvider.select((options) => options),
    );
    final currentStatusId = order.statusRaw.trim().isNotEmpty
        ? order.statusRaw
        : orderDetailStatusLabel(order.status);
    final steps = orderTrackingStepsFromApi(
      currentStatusId: currentStatusId,
      statuses: statusOptions,
      fallbackStatus: order.status,
    );

    return ListView(
      padding: EdgeInsets.all(20.r),
      children: [
        OrderDetailSectionCard(
          title: Strings.orderStatus,
          titleIcon: Icons.receipt_long_rounded,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                order.displayOrderId.isNotEmpty
                    ? order.displayOrderId
                    : Strings.emDash,
                style: FontPalette.base700(18, color: colors.primaryText),
              ),
              if (order.etaText?.isNotEmpty ?? false) ...[
                12.verticalSpace,
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.inputBackground.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          MedpikSvgAssets.calendar,
                          width: 16.r,
                          height: 16.r,
                          fit: BoxFit.contain,
                          colorFilter: ColorFilter.mode(
                            colors.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                        8.horizontalSpace,
                        Expanded(
                          child: Text(
                            order.etaText ?? '',
                            style: FontPalette.base500(
                              14,
                              color: colors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        18.verticalSpace,
        OrderDetailSectionCard(
          title: Strings.tracking,
          titleIcon: Icons.route_rounded,
          child: Column(
            children: [
              for (var i = 0; i < steps.length; i++)
                OrderTrackingStepTile(
                  step: steps[i],
                  isLast: i == steps.length - 1,
                  isCurrent:
                      steps[i].isCompleted &&
                      (i == steps.length - 1 || !steps[i + 1].isCompleted),
                  index: i,
                  primaryColor: colors.primary,
                  inputBorderColor: colors.inputBorder,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

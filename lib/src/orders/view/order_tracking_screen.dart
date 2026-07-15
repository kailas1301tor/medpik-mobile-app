// lib/src/orders/view/order_tracking_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tsuite/data/models/order_model.dart';
import 'package:tsuite/res/constants/medpik_svg_assets.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/orders/notifier/orders_notifier.dart';
import 'package:tsuite/src/orders/view/widget/order_tracking_step_tile.dart';
import 'package:tsuite/utils/common_widgets/common_app_bar.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';
import 'package:tsuite/utils/common_widgets/common_loader.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';
import 'package:tsuite/utils/common_widgets/common_switch_state.dart';
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
      ordersNotifierProvider.select((s) => s.detailLoaderState),
    );
    final order = ref.watch(
      ordersNotifierProvider.select((s) => s.selectedOrder),
    );

    return CommonScaffold(
      appBar: const CommonAppBar(title: Strings.trackOrder),
      backgroundColor: colors.background,
      body: CommonSwitchState(
        loaderState: loaderState,
        reload: () => ref
            .read(ordersNotifierProvider.notifier)
            .loadOrderDetail(widget.orderId),
        buttonText: Strings.refresh,
        loader: const Center(child: CommonLoader()),
        child: order == null
            ? const SizedBox.shrink()
            : _OrderTrackingBody(order: order),
      ),
    );
  }
}

class _OrderTrackingBody extends StatelessWidget {
  const _OrderTrackingBody({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final steps = orderTrackingSteps(order.status);

    return ListView.builder(
      padding: EdgeInsets.all(20.r),
      itemCount: steps.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      style: FontPalette.base700(
                        16,
                        color: colors.primaryText,
                      ),
                    ),
                    if (order.etaText?.isNotEmpty ?? false) ...[
                      8.verticalSpace,
                      Row(
                        children: [
                          SvgPicture.asset(
                            MedpikSvgAssets.calendar,
                            width: 16.r,
                            height: 16.r,
                            fit: BoxFit.contain,
                          ),
                          8.horizontalSpace,
                          Expanded(
                            child: Text(
                              order.etaText!,
                              style: FontPalette.base500(
                                14,
                                color: colors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              24.verticalSpace,
            ],
          );
        }

        final stepIndex = index - 1;
        final step = steps[stepIndex];
        return OrderTrackingStepTile(
          step: step,
          isLast: stepIndex == steps.length - 1,
          primaryColor: colors.primary,
          inputBorderColor: colors.inputBorder,
        );
      },
    );
  }
}

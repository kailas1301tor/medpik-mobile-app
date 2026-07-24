// lib/src/orders/view/order_payment_failure_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/generated/assets.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/src/orders/model/order_payment_result_args.dart';
import 'package:medpik/utils/common_widgets/common_empty_state.dart';
import 'package:medpik/utils/common_widgets/common_scaffold.dart';
import 'package:medpik/utils/common_widgets/primary_button.dart';
import 'package:medpik/utils/routes/route_constants.dart';

class OrderPaymentFailureScreen extends StatelessWidget {
  const OrderPaymentFailureScreen({super.key, required this.args});

  final OrderPaymentResultArgs args;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final content = OrderPaymentFailureContent.fromArgs(args);

    return CommonScaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              Expanded(
                child: CommonEmptyState(
                  title: content.title,
                  message: content.message,
                  imageAsset: Assets.lottieError,
                  fillAvailableSpace: false,
                ),
              ),
              PrimaryButton(
                text: Strings.tryPaymentAgain,
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    RouteConstants.routeOrderReviewPayScreen,
                    arguments: args.orderId,
                  );
                },
              ),
              12.verticalSpace,
              PrimaryButton(
                text: Strings.viewOrder,
                height: 44.h,
                backgroundColor: colors.surface,
                textColor: colors.primary,
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RouteConstants.routeOrderDetailScreen,
                    (route) =>
                        route.settings.name == RouteConstants.mainScreen ||
                        route.isFirst,
                    arguments: args.orderId,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// lib/src/orders/view/order_payment_success_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/orders/model/order_payment_result_args.dart';
import 'package:medpik/utils/common_widgets/common_scaffold.dart';
import 'package:medpik/utils/common_widgets/common_success_lottie.dart';
import 'package:medpik/utils/common_widgets/primary_button.dart';
import 'package:medpik/utils/routes/route_constants.dart';

class OrderPaymentSuccessScreen extends StatelessWidget {
  const OrderPaymentSuccessScreen({super.key, required this.args});

  final OrderPaymentResultArgs args;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return CommonScaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CommonSuccessLottie(),
              8.verticalSpace,
              Text(
                Strings.paymentSuccessTitle,
                style: FontPalette.base700(24, color: colors.primaryText),
                textAlign: TextAlign.center,
              ),
              12.verticalSpace,
              Text(
                Strings.paymentSuccessMessage,
                textAlign: TextAlign.center,
                style: FontPalette.base400(14, color: colors.secondaryText),
              ),
              12.verticalSpace,
              Text(
                '${Strings.orderIdLabel}: ${args.orderId}',
                style: FontPalette.base500(16, color: colors.secondaryText),
              ),
              40.verticalSpace,
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: Strings.trackOrder,
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RouteConstants.routeTrackingScreen,
                      (route) =>
                          route.settings.name == RouteConstants.mainScreen,
                      arguments: args.orderId,
                    );
                  },
                ),
              ),
              12.verticalSpace,
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: Strings.continueShopping,
                  height: 44.h,
                  backgroundColor: colors.surface,
                  textColor: colors.primary,
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RouteConstants.mainScreen,
                      (route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

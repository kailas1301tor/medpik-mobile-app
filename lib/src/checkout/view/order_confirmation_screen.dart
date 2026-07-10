// lib/src/checkout/view/order_confirmation_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';
import 'package:tsuite/utils/common_widgets/primary_button.dart';
import 'package:tsuite/utils/routes/route_constants.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return CommonScaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, size: 80.r, color: colors.primary),
              24.verticalSpace,
              Text(
                Strings.orderPlacedSuccess,
                style: FontPalette.base700(24, color: colors.primaryText),
                textAlign: TextAlign.center,
              ),
              12.verticalSpace,
              Text(
                '${Strings.orderIdLabel}: $orderId',
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
                      (route) => route.settings.name == RouteConstants.mainScreen,
                      arguments: orderId,
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

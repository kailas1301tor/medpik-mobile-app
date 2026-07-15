// lib/src/orders/view/widget/order_payment_method_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';

class OrderPaymentMethodCard extends StatelessWidget {
  const OrderPaymentMethodCard({
    super.key,
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  final OrderPaymentMethod method;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isOnline = method == OrderPaymentMethod.online;

    return CommonContainer(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      borderRadius: 12.r,
      color: colors.surface,
      border: Border.all(
        color: isSelected ? colors.primary : colors.inputBorder,
        width: isSelected ? 1.5.w : 1.w,
      ),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isSelected
                ? Icons.radio_button_checked_rounded
                : Icons.radio_button_off_rounded,
            size: 20.r,
            color: isSelected ? colors.primary : colors.secondaryText,
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isOnline ? Strings.payNowOnline : Strings.cashOnDelivery,
                  style: FontPalette.base600(14, color: colors.primaryText),
                ),
                4.verticalSpace,
                Text(
                  isOnline
                      ? Strings.payNowOnlineSubtitle
                      : Strings.cashOnDeliverySubtitle,
                  style: FontPalette.base400(12, color: colors.secondaryText),
                ),
              ],
            ),
          ),
          Icon(
            isOnline ? Icons.credit_card_outlined : Icons.payments_outlined,
            size: 22.r,
            color: colors.secondaryText,
          ),
        ],
      ),
    );
  }
}

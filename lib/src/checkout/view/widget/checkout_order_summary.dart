// lib/src/checkout/view/widget/checkout_order_summary.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/cart/model/cart_item_model.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';

class CheckoutOrderSummary extends StatelessWidget {
  const CheckoutOrderSummary({
    super.key,
    required this.cartItems,
  });

  final List<CartItemModel> cartItems;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          Strings.orderSummary,
          style: FontPalette.base700(16, color: colors.primaryText),
        ),
        12.verticalSpace,
        for (final item in cartItems)
          CommonContainer(
            margin: EdgeInsets.only(bottom: 8.h),
            padding: EdgeInsets.all(12.r),
            borderRadius: 12.r,
            color: colors.surface,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.product.name,
                    style: FontPalette.base500(14, color: colors.primaryText),
                  ),
                ),
                Text(
                  Strings.quantityTimes(item.quantity),
                  style: FontPalette.base400(13, color: colors.secondaryText),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

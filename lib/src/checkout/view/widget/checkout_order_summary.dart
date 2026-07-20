// lib/src/checkout/view/widget/checkout_order_summary.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/cart/model/cart_item_model.dart';
import 'package:tsuite/src/checkout/view/widget/checkout_product_tile.dart';

class CheckoutOrderSummary extends StatelessWidget {
  const CheckoutOrderSummary({super.key, required this.cartItems});

  final List<CartItemModel> cartItems;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final totalQty = cartItems.fold<int>(0, (sum, i) => sum + i.quantity);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.selectedMedicinesWithCount(totalQty),
          style: FontPalette.base700(16, color: colors.primaryText),
        ),
        10.verticalSpace,
        for (var i = 0; i < cartItems.length; i++) ...[
          CheckoutProductTile(item: cartItems[i]),
          if (i < cartItems.length - 1) 8.verticalSpace,
        ],
      ],
    );
  }
}

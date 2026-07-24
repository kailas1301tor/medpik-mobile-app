// lib/src/checkout/view/widget/checkout_order_summary.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/data/models/cart_item_model.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/checkout/view/widget/checkout_product_tile.dart';

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
        8.verticalSpace,
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
            return CheckoutProductTile(
              item: cartItems[index],
              showDivider: index < cartItems.length - 1,
            );
          },
        ),
      ],
    );
  }
}

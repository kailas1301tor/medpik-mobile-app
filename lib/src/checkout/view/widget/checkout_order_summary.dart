// lib/src/checkout/view/widget/checkout_order_summary.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/data/models/cart_item_model.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/src/checkout/view/widget/checkout_product_tile.dart';
import 'package:medpik/src/checkout/view/widget/checkout_section_card.dart';

class CheckoutOrderSummary extends StatelessWidget {
  const CheckoutOrderSummary({super.key, required this.cartItems});

  final List<CartItemModel> cartItems;

  @override
  Widget build(BuildContext context) {
    final totalQty = cartItems.fold<int>(0, (sum, i) => sum + i.quantity);

    return CheckoutSectionCard(
      title: Strings.selectedMedicinesWithCount(totalQty),
      titleIcon: Icons.medication_liquid_rounded,
      padding: EdgeInsets.fromLTRB(16.r, 16.r, 16.r, 4.r),
      child: ListView.builder(
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
    );
  }
}

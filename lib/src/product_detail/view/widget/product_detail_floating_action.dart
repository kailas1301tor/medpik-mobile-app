// lib/src/product_detail/view/widget/product_detail_floating_action.dart
import 'package:flutter/material.dart';
import 'package:medpik/utils/common_widgets/common_back_button.dart';

class ProductDetailFloatingAction extends StatelessWidget {
  const ProductDetailFloatingAction({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    if (icon == Icons.arrow_back_ios_new_rounded) {
      return CommonBackButton(onTap: onTap, overlayStyle: true);
    }

    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: iconColor),
    );
  }
}

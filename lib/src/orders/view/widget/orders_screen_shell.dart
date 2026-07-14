// lib/src/orders/view/widget/orders_screen_shell.dart
import 'package:flutter/material.dart';
import 'package:tsuite/src/orders/view/widget/orders_screen_header.dart';

class OrdersScreenShell extends StatelessWidget {
  const OrdersScreenShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const OrdersScreenHeader(),
        Expanded(child: child),
      ],
    );
  }
}

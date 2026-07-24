// lib/src/orders/view/widget/orders_screen_shell.dart
import 'package:flutter/material.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/utils/common_widgets/shell_tab_header.dart';

class OrdersScreenShell extends StatelessWidget {
  const OrdersScreenShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ShellTabHeader(title: Strings.ordersTitle),
        Expanded(child: child),
      ],
    );
  }
}

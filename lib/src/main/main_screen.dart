// lib/src/main/main_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/src/cart/view/cart_screen.dart';
import 'package:tsuite/src/home/view/home_screen.dart';
import 'package:tsuite/src/main/notifier/main_shell_notifier.dart';
import 'package:tsuite/src/main/view/widget/bottom_navigation_section.dart';
import 'package:tsuite/src/orders/view/orders_screen.dart';
import 'package:tsuite/src/profile/view/profile_screen.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final selectedTab = ref.watch(mainShellNotifierProvider);

    const pages = [HomeScreen(), OrdersScreen(), CartScreen(), ProfileScreen()];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        final shouldExit = ref
            .read(mainShellNotifierProvider.notifier)
            .handleBackPress();
        if (shouldExit) {
          SystemNavigator.pop();
        }
      },
      child: CommonScaffold(
        backgroundColor: colors.background,
        enableFadeIn: false,
        extendBody: true,
        safeAreaTop: false,
        body: IndexedStack(index: selectedTab, children: pages),
        bottomNavigationBar: const BottomNavigationSection(),
      ),
    );
  }
}

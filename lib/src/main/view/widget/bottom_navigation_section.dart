// lib/src/main/view/widget/bottom_navigation_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tsuite/res/constants/medpik_svg_assets.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/cart/notifier/cart_notifier.dart';
import 'package:tsuite/src/main/notifier/main_shell_notifier.dart';

class BottomNavigationSection extends ConsumerWidget {
  const BottomNavigationSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final selectedTab = ref.watch(mainShellNotifierProvider);
    final cartCount = ref.watch(
      cartNotifierProvider.select(
        (s) => s.items.fold<int>(0, (sum, item) => sum + item.quantity),
      ),
    );

    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        // height: 80.h,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(
            color: colors.inputBorder.withValues(alpha: 0.5),
            width: 1.w,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomNavTile(
              index: 0,
              selectedIndex: selectedTab,
              label: Strings.navHome,
              icon: MedpikSvgAssets.home,
              onTap: () =>
                  ref.read(mainShellNotifierProvider.notifier).setTab(0),
            ),
            BottomNavTile(
              index: 1,
              selectedIndex: selectedTab,
              label: Strings.navOrders,
              icon: MedpikSvgAssets.calendar,
              onTap: () =>
                  ref.read(mainShellNotifierProvider.notifier).setTab(1),
            ),
            BottomNavTile(
              index: 2,
              selectedIndex: selectedTab,
              label: Strings.navCart,
              icon: MedpikSvgAssets.cart,
              badgeCount: cartCount,
              onTap: () =>
                  ref.read(mainShellNotifierProvider.notifier).setTab(2),
            ),
            BottomNavTile(
              index: 3,
              selectedIndex: selectedTab,
              label: Strings.navProfile,
              icon: MedpikSvgAssets.profile,
              onTap: () =>
                  ref.read(mainShellNotifierProvider.notifier).setTab(3),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavTile extends StatelessWidget {
  const BottomNavTile({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.label,
    required this.icon,
    required this.onTap,
    this.badgeCount = 0,
  });

  final int index;
  final int selectedIndex;
  final String label;
  final String icon;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 70.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isSelected ? 1 : 0.55,
                  child: SvgPicture.asset(icon, width: 32.r, height: 32.r),
                ),
                if (badgeCount > 0)
                  Positioned(
                    right: -6.w,
                    top: -4.h,
                    child: Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        color: colors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$badgeCount',
                        style: FontPalette.base600(
                          8,
                          color: ColorPalette.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            6.verticalSpace,
            Text(
              label,
              style: FontPalette.base500(
                10,
                color: isSelected ? colors.primary : colors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

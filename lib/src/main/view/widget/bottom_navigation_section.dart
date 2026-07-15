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
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(
            color: colors.cardBorder.withValues(alpha: 0.7),
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
              icon: MedpikSvgAssets.orders,
              onTap: () =>
                  ref.read(mainShellNotifierProvider.notifier).setTab(1),
            ),
            BottomNavTile(
              index: 2,
              selectedIndex: selectedTab,
              label: Strings.navCart,
              icon: MedpikSvgAssets.shopping,
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
                AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  scale: isSelected ? 1.06 : 1,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isSelected ? 1 : 0.88,
                    child: SvgPicture.asset(
                      icon,
                      width: isSelected ? 34.r : 32.r,
                      height: isSelected ? 34.r : 32.r,
                    ),
                  ),
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
              style: isSelected
                  ? FontPalette.base600(11, color: colors.primary)
                  : FontPalette.base500(10, color: colors.secondaryText),
            ),
          ],
        ),
      ),
    );
  }
}

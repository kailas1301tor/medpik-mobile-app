// lib/src/main/view/widget/bottom_navigation_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medpik/res/constants/medpik_svg_assets.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/providers/cart_providers.dart';
import 'package:medpik/providers/shell_providers.dart';
import 'package:medpik/utils/helpers/shell_insets_helper.dart' as shell_insets;

class BottomNavigationSection extends StatelessWidget {
  const BottomNavigationSection({super.key});

  /// Clearance below a docked tab CTA.
  static double dockedFooterInset(BuildContext context, {double gap = 8}) {
    return shell_insets.dockedFooterInset(context, gap: gap);
  }

  @override
  Widget build(BuildContext context) {
    return const _BottomNavigationBody();
  }
}

class _BottomNavigationBody extends ConsumerWidget {
  const _BottomNavigationBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final selectedTab = ref.watch(mainShellNotifierProvider);

    return SafeArea(
      top: false,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(color: colors.cardBorder, width: 1.w),
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
            _CartBottomNavTile(
              selectedIndex: selectedTab,
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

class _CartBottomNavTile extends ConsumerWidget {
  const _CartBottomNavTile({required this.selectedIndex, required this.onTap});

  final int selectedIndex;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(
      cartNotifierProvider.select(
        (s) => s.items.fold<int>(0, (sum, item) => sum + item.quantity),
      ),
    );

    return BottomNavTile(
      index: 2,
      selectedIndex: selectedIndex,
      label: Strings.navCart,
      icon: MedpikSvgAssets.shopping,
      badgeCount: cartCount,
      onTap: onTap,
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
        width: 64.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 36.r,
              height: 36.r,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  AnimatedScale(
                    scale: isSelected ? 1 : 0.875,
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    child: SvgPicture.asset(
                      icon,
                      width: 36.r,
                      height: 36.r,
                      colorFilter: ColorFilter.mode(
                        isSelected ? colors.primary : colors.secondaryText,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  if (badgeCount > 0)
                    Positioned(
                      top: -2.h,
                      right: -4.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 1.h,
                        ),
                        decoration: BoxDecoration(
                          color: ColorPalette.productAccentTeal,
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        constraints: BoxConstraints(minWidth: 16.r),
                        child: Text(
                          badgeCount > 99 ? '99+' : '$badgeCount',
                          textAlign: TextAlign.center,
                          style: FontPalette.base700(
                            9,
                            color: ColorPalette.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            4.verticalSpace,
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              style: FontPalette.base500(
                10,
                color: isSelected ? colors.primary : colors.secondaryText,
              ),
              child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}

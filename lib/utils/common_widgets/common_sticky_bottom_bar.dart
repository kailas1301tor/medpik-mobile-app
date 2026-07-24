// lib/utils/common_widgets/common_sticky_bottom_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';

/// Docked footer for primary CTAs. Callers should set `safeAreaBottom: false`
/// on [CommonScaffold] so this bar can extend into the home-indicator area.
class CommonStickyBottomBar extends StatelessWidget {
  const CommonStickyBottomBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final viewBottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        border: Border(top: BorderSide(color: colors.divider)),
        boxShadow: [
          BoxShadow(
            color: ColorPalette.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: Offset(0, -6.h),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: viewBottomInset),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h),
          child: child,
        ),
      ),
    );
  }
}

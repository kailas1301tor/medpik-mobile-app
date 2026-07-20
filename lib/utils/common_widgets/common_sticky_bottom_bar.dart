// lib/utils/common_widgets/common_sticky_bottom_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/styles/color_palette.dart';

class CommonStickyBottomBar extends StatelessWidget {
  const CommonStickyBottomBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h + bottomInset),
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
      child: child,
    );
  }
}

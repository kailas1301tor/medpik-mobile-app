// /Users/wac/Documents/tortilon/medpik/lib/utils/common_widgets/common_nav_bar_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';

class CommonNavBarButton extends StatelessWidget {
  const CommonNavBarButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.badgeCount,
  });

  final Widget icon;
  final VoidCallback onTap;
  final int? badgeCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(100.r),
          onTap: onTap,
          child: Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: colors.inputBackground,
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Center(child: icon),
                if ((badgeCount ?? 0) > 0)
                  Positioned(
                    top: 6.h,
                    right: 6.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: colors.errorText,
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Text(
                        '${badgeCount!}',
                        style: FontPalette.base600(
                          10,
                          color: ColorPalette.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

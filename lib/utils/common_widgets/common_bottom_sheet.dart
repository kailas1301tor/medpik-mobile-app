// /Users/wac/Documents/wac projects/tsuite/lib/utils/common_widgets/common_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/utils/common_widgets/common_nav_bar_button.dart';

class CommonBottomSheet extends StatelessWidget {
  const CommonBottomSheet({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget child,
    bool isScrollControlled = false,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      builder: (_) => CommonBottomSheet(title: title, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h + bottomInset),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: colors.inputBorder,
              borderRadius: BorderRadius.circular(999.r),
            ),
          ),
          16.verticalSpace,
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: FontPalette.base700(18, color: colors.primaryText),
                ),
              ),
              CommonNavBarButton(
                icon: Icon(
                  Icons.close_rounded,
                  size: 18.r,
                  color: colors.primaryText,
                ),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          16.verticalSpace,
          child,
        ],
      ),
    );
  }
}

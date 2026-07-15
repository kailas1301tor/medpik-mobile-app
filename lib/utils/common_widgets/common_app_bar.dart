import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final double elevation;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final bool centerTitle;
  final Color? titleColor;
  final Color? iconColor;

  const CommonAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
    this.elevation = 0,
    this.leading,
    this.bottom,
    this.centerTitle = true,
    this.titleColor,
    this.iconColor,
  });

  SystemUiOverlayStyle _resolveOverlayStyle(Color bgColor) {
    final luminance = bgColor.computeLuminance();
    final iconsAreDark = luminance > 0.179;

    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,

      // Android
      statusBarIconBrightness: iconsAreDark
          ? Brightness.dark
          : Brightness.light,

      // iOS
      statusBarBrightness: iconsAreDark ? Brightness.light : Brightness.dark,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final effectiveBgColor = backgroundColor ?? colors.background;
    final effectiveTitleColor = titleColor ?? colors.primaryText;
    final effectiveIconColor = iconColor ?? colors.primaryText;

    return AppBar(
      title:
          titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: FontPalette.base600(16, color: effectiveTitleColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null),
      centerTitle: centerTitle,
      backgroundColor: effectiveBgColor,
      surfaceTintColor: Colors.transparent,
      elevation: elevation,
      scrolledUnderElevation: elevation,

      // ✅ Always auto-computed — never null
      systemOverlayStyle: _resolveOverlayStyle(effectiveBgColor),
      actionsPadding: EdgeInsets.only(right: 16.w),
      leading:
          leading ??
          (showBackButton
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20.r,
                    color: effectiveIconColor,
                  ),
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                )
              : null),
      actions: actions,
      bottom: bottom,
      iconTheme: IconThemeData(color: effectiveIconColor),
      actionsIconTheme: IconThemeData(color: effectiveIconColor),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}

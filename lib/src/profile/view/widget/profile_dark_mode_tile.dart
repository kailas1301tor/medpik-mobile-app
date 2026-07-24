// lib/src/profile/view/widget/profile_dark_mode_tile.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/res/styles/theme_provider.dart';

class ProfileDarkModeTile extends ConsumerWidget {
  const ProfileDarkModeTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final isDark = ref.watch(
      themeNotifierProvider.select((s) => s.valueOrNull == ThemeMode.dark),
    );

    return Column(
      children: [
        Material(
          color: colors.surface,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Row(
              children: [
                Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    color: ColorPalette.productAccentTeal.withValues(
                      alpha: 0.1,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.dark_mode_outlined,
                    size: 18.r,
                    color: ColorPalette.productAccentTeal,
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Strings.darkMode,
                        style: FontPalette.base600(
                          14,
                          color: colors.primaryText,
                        ),
                      ),
                      2.verticalSpace,
                      Text(
                        Strings.darkModeSubtitle,
                        style: FontPalette.base400(
                          11,
                          color: colors.secondaryText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: isDark,
                  activeTrackColor: colors.primary,
                  onChanged: (value) => ref
                      .read(themeNotifierProvider.notifier)
                      .setThemeMode(
                        value ? ThemeMode.dark : ThemeMode.light,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

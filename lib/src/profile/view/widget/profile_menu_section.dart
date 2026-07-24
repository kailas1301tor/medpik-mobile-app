// lib/src/profile/view/widget/profile_menu_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/utils/common_widgets/common_container.dart';

class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            title,
            style: FontPalette.base700(14, color: colors.primaryText),
          ),
        ),
        CommonContainer(
          padding: EdgeInsets.zero,
          borderRadius: 16.r,
          color: colors.surface,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }
}

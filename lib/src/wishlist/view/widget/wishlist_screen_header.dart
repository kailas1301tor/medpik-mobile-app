// lib/src/wishlist/view/widget/wishlist_screen_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';

class WishlistScreenHeader extends StatelessWidget {
  const WishlistScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(8.w, 8.h, 16.w, 16.h),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20.r,
                color: colors.primaryText,
              ),
            ),
            Expanded(
              child: Text(
                Strings.wishlistTitle,
                style: FontPalette.base700(24, color: colors.primaryText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// lib/src/auth/view/widget/login_social_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tsuite/res/constants/assets.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/utils/common_widgets/common_inline_loader.dart';

class LoginSocialButton extends StatelessWidget {
  const LoginSocialButton({
    super.key,
    required this.isLoading,
    required this.onTap,
  });

  final bool isLoading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final borderRadius = BorderRadius.circular(100.r);

    return Material(
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: BorderSide(color: colors.inputBorder),
      ),
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: borderRadius,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                Assets.svgGoogleLogo,
                width: 20.r,
                height: 20.r,
              ),
              10.horizontalSpace,
              Flexible(
                child: Text(
                  Strings.continueWithGoogle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FontPalette.base600(15, color: colors.primaryText),
                ),
              ),
              if (isLoading) ...[
                10.horizontalSpace,
                CommonInlineLoader(size: 18.r),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

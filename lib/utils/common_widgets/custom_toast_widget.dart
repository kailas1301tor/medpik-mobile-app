import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:medpik/res/constants/assets.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';

class CustomToastWidget extends StatelessWidget {
  const CustomToastWidget({
    super.key,
    required this.message,
    this.link,
    this.isSuccess,
    this.onLinkTap,
    this.increaseBottomPadding,
  });

  final String message;
  final String? link;
  final bool? isSuccess;
  final VoidCallback? onLinkTap;
  final bool? increaseBottomPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: (increaseBottomPadding ?? false) ? 70 : 0,
      ),
      child: SmoothContainer(
        width: double.maxFinite,
        margin: EdgeInsets.all(16.w),
        smoothness: 3,
        color: ColorPalette.black,
        borderRadius: BorderRadius.circular(100.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Main toast section expands
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSuccess != null) ...[
                      SvgPicture.asset(
                        (isSuccess ?? false)
                            ? Assets.svgToastSuccess
                            : Assets.svgToastError,
                        height: 20.h,
                        width: 20.w,
                      ),
                      SizedBox(width: 8.w),
                    ],
                    Flexible(
                      child: Text(
                        message,
                        style: FontPalette.fWhite_14_600,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // link section with only needed width
            if (link != null) ...[
              Container(height: 24.h, width: 1.w, color: ColorPalette.f4F4F4F),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onLinkTap,
                  child: Text(
                    link ?? '',
                    style: FontPalette.fWhite_14_600.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// /Users/wac/Documents/tortilon/medpik/lib/utils/common_widgets/common_empty_state.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/utils/common_widgets/primary_button.dart';

class CommonEmptyState extends StatelessWidget {
  const CommonEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.imageAsset,
    this.buttonText,
    this.onPressed,
    this.titleStyle,
    this.messageStyle,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.topSpacing,
    this.fillAvailableSpace = true,
    this.backgroundColor,
  });

  final String title;
  final String message;
  final String? imageAsset;
  final String? buttonText;
  final VoidCallback? onPressed;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;
  final MainAxisAlignment mainAxisAlignment;
  final double? topSpacing;
  final bool fillAvailableSpace;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        if (topSpacing != null) SizedBox(height: topSpacing),
        _StateIllustration(assetPath: imageAsset),
        20.verticalSpace,
        Text(
          title,
          textAlign: TextAlign.center,
          style:
              titleStyle ?? FontPalette.base700(18, color: colors.primaryText),
        ),
        8.verticalSpace,
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 280.w),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style:
                messageStyle ??
                FontPalette.base400(14, color: colors.secondaryText),
          ),
        ),
        if (buttonText != null && onPressed != null) ...[
          24.verticalSpace,
          SizedBox(
            width: 180.w,
            child: PrimaryButton(
              text: buttonText ?? Strings.retry,
              onPressed: onPressed,
            ),
          ),
        ],
      ],
    );

    if (!fillAvailableSpace) {
      return Container(
        width: double.maxFinite,
        color: backgroundColor ?? Colors.transparent,
        child: content,
      );
    }

    return SizedBox.expand(
      child: ColoredBox(
        color: backgroundColor ?? Colors.transparent,
        child: Center(child: content),
      ),
    );
  }
}

class _StateIllustration extends StatelessWidget {
  const _StateIllustration({required this.assetPath});

  final String? assetPath;

  @override
  Widget build(BuildContext context) {
    if (assetPath == null || assetPath!.isEmpty) {
      return Icon(
        Icons.inbox_outlined,
        size: 82.r,
        color: context.appColors.secondaryText,
      );
    }

    if (assetPath!.endsWith('.json')) {
      return SizedBox.square(
        dimension: 190.r,
        child: Lottie.asset(
          assetPath!,
          repeat: true,
          errorBuilder: (_, __, ___) => Icon(
            Icons.inbox_outlined,
            size: 82.r,
            color: context.appColors.secondaryText,
          ),
        ),
      );
    }

    return SizedBox.square(
      dimension: 120.r,
      child: SvgPicture.asset(
        assetPath!,
        placeholderBuilder: (_) => const CupertinoActivityIndicator(),
      ),
    );
  }
}

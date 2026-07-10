// /Users/wac/Documents/wac projects/tsuite/lib/utils/common_widgets/common_error_state.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/utils/common_widgets/primary_button.dart';

class CommonErrorState extends StatelessWidget {
  const CommonErrorState({
    super.key,
    required this.title,
    required this.message,
    this.imageAsset,
    this.buttonText,
    this.onRetry,
    this.isLoading = false,
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
  final VoidCallback? onRetry;
  final bool isLoading;
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
      mainAxisSize: fillAvailableSpace ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        if (topSpacing != null) SizedBox(height: topSpacing),
        _ErrorIllustration(assetPath: imageAsset),
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
        if (buttonText != null && onRetry != null) ...[
          24.verticalSpace,
          SizedBox(
            width: 180.w,
            child: PrimaryButton(
              text: buttonText ?? Strings.retry,
              isLoading: isLoading,
              onPressed: onRetry,
            ),
          ),
        ],
      ],
    );

    return Container(
      width: double.maxFinite,
      color: backgroundColor ?? Colors.transparent,
      child: fillAvailableSpace ? Center(child: content) : content,
    );
  }
}

class _ErrorIllustration extends StatelessWidget {
  const _ErrorIllustration({required this.assetPath});

  final String? assetPath;

  @override
  Widget build(BuildContext context) {
    if (assetPath == null || assetPath!.isEmpty) {
      return Icon(
        Icons.error_outline_rounded,
        size: 82.r,
        color: context.appColors.secondaryText,
      );
    }

    if (assetPath!.endsWith('.json')) {
      return SizedBox.square(
        dimension: 190.r,
        child: Lottie.asset(
          assetPath!,
          repeat: false,
          errorBuilder: (_, __, ___) => Icon(
            Icons.error_outline_rounded,
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

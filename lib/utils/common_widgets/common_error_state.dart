// /Users/wac/Documents/tortilon/medpik/lib/utils/common_widgets/common_error_state.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/utils/common_widgets/primary_button.dart';
import 'package:medpik/utils/common_widgets/common_state_illustration.dart';

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
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        if (topSpacing != null) SizedBox(height: topSpacing),
        CommonStateIllustration(
          assetPath: imageAsset,
          fallbackIcon: Icons.error_outline_rounded,
          lottieRepeat: false,
        ),
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

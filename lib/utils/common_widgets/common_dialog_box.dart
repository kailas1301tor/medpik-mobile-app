// /Users/wac/Documents/tortilon/medpik/lib/utils/common_widgets/common_dialog_box.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/utils/common_widgets/primary_button.dart';

class CommonDialogBox extends StatelessWidget {
  const CommonDialogBox({
    super.key,
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
  });

  final String title;
  final String message;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String message,
    required String primaryLabel,
    required VoidCallback onPrimary,
    String? secondaryLabel,
    VoidCallback? onSecondary,
  }) {
    return showDialog<T>(
      context: context,
      builder: (_) => CommonDialogBox(
        title: title,
        message: message,
        primaryLabel: primaryLabel,
        onPrimary: onPrimary,
        secondaryLabel: secondaryLabel,
        onSecondary: onSecondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: FontPalette.base700(20, color: colors.primaryText),
            ),
            12.verticalSpace,
            Text(
              message,
              textAlign: TextAlign.center,
              style: FontPalette.base400(14, color: colors.secondaryText),
            ),
            24.verticalSpace,
            SizedBox(
              width: double.maxFinite,
              child: PrimaryButton(
                text: primaryLabel,
                onPressed: () {
                  Navigator.of(context).pop();
                  onPrimary();
                },
              ),
            ),
            if (secondaryLabel != null) ...[
              8.verticalSpace,
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onSecondary?.call();
                },
                child: Text(
                  secondaryLabel ?? Strings.cancel,
                  style: FontPalette.base600(14, color: colors.secondaryText),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

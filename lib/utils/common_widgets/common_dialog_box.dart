// lib/utils/common_widgets/common_dialog_box.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/utils/common_widgets/primary_button.dart';

class CommonDialogBox extends StatefulWidget {
  const CommonDialogBox({
    super.key,
    required this.title,
    required this.message,
    required this.primaryLabel,
    this.onPrimary,
    this.onPrimaryAsync,
    this.isLoading,
    this.secondaryLabel,
    this.onSecondary,
  });

  final String title;
  final String message;
  final String primaryLabel;
  final VoidCallback? onPrimary;
  final Future<bool> Function()? onPrimaryAsync;
  final bool? isLoading;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String message,
    required String primaryLabel,
    VoidCallback? onPrimary,
    Future<bool> Function()? onPrimaryAsync,
    bool? isLoading,
    String? secondaryLabel,
    VoidCallback? onSecondary,
  }) {
    assert(
      (onPrimary != null && onPrimaryAsync == null) ||
          (onPrimary == null && onPrimaryAsync != null),
      'Provide exactly one of onPrimary or onPrimaryAsync',
    );

    return showDialog<T>(
      context: context,
      builder: (_) => CommonDialogBox(
        title: title,
        message: message,
        primaryLabel: primaryLabel,
        onPrimary: onPrimary,
        onPrimaryAsync: onPrimaryAsync,
        isLoading: isLoading,
        secondaryLabel: secondaryLabel,
        onSecondary: onSecondary,
      ),
    );
  }

  @override
  State<CommonDialogBox> createState() => _CommonDialogBoxState();
}

class _CommonDialogBoxState extends State<CommonDialogBox> {
  bool _isLoading = false;

  bool get _effectiveLoading => widget.isLoading ?? _isLoading;

  Future<void> _handlePrimary() async {
    if (_effectiveLoading) return;

    if (widget.onPrimaryAsync != null) {
      if (widget.isLoading == null) {
        setState(() => _isLoading = true);
      }
      try {
        final shouldPop = await widget.onPrimaryAsync!();
        if (shouldPop && mounted) {
          Navigator.of(context).pop();
        }
      } finally {
        if (widget.isLoading == null && mounted) {
          setState(() => _isLoading = false);
        }
      }
      return;
    }

    Navigator.of(context).pop();
    widget.onPrimary?.call();
  }

  void _handleSecondary() {
    if (_effectiveLoading) return;
    Navigator.of(context).pop();
    widget.onSecondary?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isLoading = _effectiveLoading;

    return PopScope(
      canPop: !isLoading,
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: FontPalette.base700(20, color: colors.primaryText),
              ),
              12.verticalSpace,
              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: FontPalette.base400(14, color: colors.secondaryText),
              ),
              24.verticalSpace,
              SizedBox(
                width: double.maxFinite,
                child: PrimaryButton(
                  text: widget.primaryLabel,
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _handlePrimary,
                ),
              ),
              if (widget.secondaryLabel != null) ...[
                8.verticalSpace,
                TextButton(
                  onPressed: isLoading ? null : _handleSecondary,
                  child: Text(
                    widget.secondaryLabel ?? Strings.cancel,
                    style: FontPalette.base600(14, color: colors.secondaryText),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

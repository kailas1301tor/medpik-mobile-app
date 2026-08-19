// lib/utils/common_widgets/common_search_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medpik/res/constants/assets.dart';
import 'package:medpik/res/constants/medpik_svg_assets.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/utils/common_widgets/common_text_form_field.dart';

class CommonSearchBar extends StatelessWidget {
  const CommonSearchBar({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.focusNode,
    this.trailing,
    this.prefixIcon,
    this.readOnly = false,
    this.autoFocus = false,
    this.onTap,
  });

  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final FocusNode? focusNode;
  final Widget? trailing;
  final Widget? prefixIcon;
  final bool readOnly;
  final bool autoFocus;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final fieldHeight = 50.h;
    final iconSlotWidth = 44.w;
    final iconSize = 18.r;
    final iconColor = context.appColors.secondaryText;

    final controller = this.controller;
    if (controller == null) {
      return _buildField(
        hasText: false,
        fieldHeight: fieldHeight,
        iconSlotWidth: iconSlotWidth,
        iconSize: iconSize,
        iconColor: iconColor,
      );
    }

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) => _buildField(
        hasText: value.text.isNotEmpty,
        fieldHeight: fieldHeight,
        iconSlotWidth: iconSlotWidth,
        iconSize: iconSize,
        iconColor: iconColor,
      ),
    );
  }

  Widget _buildField({
    required bool hasText,
    required double fieldHeight,
    required double iconSlotWidth,
    required double iconSize,
    required Color iconColor,
  }) {
    final showSuffix = hasText || trailing != null;

    return CommonTextFormField(
      height: fieldHeight,
      controller: controller,
      focusNode: focusNode,
      readOnly: readOnly,
      autoFocus: autoFocus,
      onTap: onTap,
      hintText: hintText ?? Strings.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      inputAction: TextInputAction.search,
      textAlignVertical: TextAlignVertical.center,
      contentPadding: EdgeInsets.only(
        top: 15.h,
        bottom: 15.h,
        right: showSuffix ? 0 : 12.w,
      ),
      suffix: _buildSuffix(
        hasText: hasText,
        fieldHeight: fieldHeight,
        iconSlotWidth: iconSlotWidth,
        iconSize: iconSize,
        iconColor: iconColor,
        trailing: trailing,
        onClear: () {
          controller?.clear();
          onClear?.call();
        },
      ),
      prefixIcon:
          prefixIcon ??
          SizedBox(
            width: iconSlotWidth,
            height: fieldHeight,
            child: Center(
              child: SvgPicture.asset(
                MedpikSvgAssets.search,
                width: iconSize,
                height: iconSize,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
          ),
      prefixIconConstraints: BoxConstraints(
        minWidth: iconSlotWidth,
        maxWidth: iconSlotWidth,
        minHeight: fieldHeight,
        maxHeight: fieldHeight,
      ),
    );
  }

  Widget? _buildSuffix({
    required bool hasText,
    required double fieldHeight,
    required double iconSlotWidth,
    required double iconSize,
    required Color iconColor,
    required Widget? trailing,
    required VoidCallback onClear,
  }) {
    final clearButton = hasText
        ? _SearchBarClearButton(
            fieldHeight: fieldHeight,
            iconSlotWidth: iconSlotWidth,
            iconSize: iconSize,
            iconColor: iconColor,
            onPressed: onClear,
          )
        : null;

    if (trailing == null) {
      return clearButton;
    }
    if (clearButton == null) {
      return trailing;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [clearButton, trailing],
    );
  }
}

class _SearchBarClearButton extends StatelessWidget {
  const _SearchBarClearButton({
    required this.fieldHeight,
    required this.iconSlotWidth,
    required this.iconSize,
    required this.iconColor,
    required this.onPressed,
  });

  final double fieldHeight;
  final double iconSlotWidth;
  final double iconSize;
  final Color iconColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: iconSlotWidth,
      height: fieldHeight,
      child: Center(
        child: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          tooltip: Strings.clear,
          onPressed: onPressed,
          icon: SvgPicture.asset(
            Assets.svgCloseIcon,
            width: iconSize,
            height: iconSize,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}

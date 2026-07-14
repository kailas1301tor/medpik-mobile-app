// /Users/wac/Documents/wac projects/tsuite/lib/utils/common_widgets/common_search_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tsuite/res/constants/assets.dart';
import 'package:tsuite/res/constants/medpik_svg_assets.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/utils/common_widgets/common_text_form_field.dart';

class CommonSearchBar extends StatelessWidget {
  const CommonSearchBar({
    super.key,
    required this.controller,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.focusNode,
    this.trailing,
    this.prefixIcon,
  });

  final TextEditingController controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final FocusNode? focusNode;
  final Widget? trailing;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final hasText = value.text.trim().isNotEmpty;

        return CommonTextFormField(
          height: 50.h,
          controller: controller,

          focusNode: focusNode,
          hintText: hintText ?? Strings.search,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          inputAction: TextInputAction.search,
          suffix:
              trailing ??
              (hasText
                  ? IconButton(
                      tooltip: Strings.clear,
                      onPressed: () {
                        controller.clear();
                        onChanged?.call('');
                        onClear?.call();
                      },
                      icon: SvgPicture.asset(
                        Assets.svgCloseIcon,
                        width: 18.r,
                        height: 18.r,
                        colorFilter: ColorFilter.mode(
                          context.appColors.secondaryText,
                          BlendMode.srcIn,
                        ),
                      ),
                    )
                  : null),
          prefixIcon:
              prefixIcon ??
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                child: SvgPicture.asset(
                  MedpikSvgAssets.search,
                  width: 18.r,
                  height: 18.r,
                ),
              ),
          prefixIconConstraints: BoxConstraints(
            minWidth: 30.w,
            minHeight: 30.h,
          ),
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        );
      },
    );
  }
}

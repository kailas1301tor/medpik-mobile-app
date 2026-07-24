// lib/src/address/view/widget/location_search_bar.dart
//
// ? Address search input for [LocationPickerScreen].
//
// ? Wraps [CommonSearchBar] with:
// ? - trailing inline loader while forward geocode runs
// ? - inline error text below field (search-specific, separate from pin errors)
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/utils/common_widgets/common_inline_loader.dart';
import 'package:medpik/utils/common_widgets/common_search_bar.dart';

class LocationSearchBar extends StatelessWidget {
  const LocationSearchBar({
    super.key,
    required this.controller,
    required this.isSearching,
    required this.searchErrorMessage,
    required this.onSubmit,
    required this.onClear,
  });

  final TextEditingController controller;
  final bool isSearching;
  final String? searchErrorMessage;
  final VoidCallback onSubmit;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final errorText = searchErrorMessage;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        IgnorePointer(
          ignoring: isSearching,
          child: CommonSearchBar(
            controller: controller,
            hintText: Strings.searchLocationHint,
            onSubmitted: (_) => onSubmit(),
            onClear: onClear,
            trailing: isSearching
                ? Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: CommonInlineLoader(size: 18.r, color: colors.primary),
                  )
                : null,
          ),
        ),
        if (errorText != null) ...[
          6.verticalSpace,
          Text(
            errorText,
            style: FontPalette.base400(12, color: colors.errorText),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}

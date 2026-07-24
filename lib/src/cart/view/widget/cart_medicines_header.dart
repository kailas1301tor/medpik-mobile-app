// lib/src/cart/view/widget/cart_medicines_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
class CartMedicinesHeader extends StatelessWidget {
  const CartMedicinesHeader({
    super.key,
    required this.itemCount,
    required this.onClearAll,
  });

  final int itemCount;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      children: [
        Expanded(
          child: Text(
            Strings.selectedMedicinesWithCount(itemCount),
            style: FontPalette.base700(16, color: colors.primaryText),
          ),
        ),
        GestureDetector(
          onTap: onClearAll,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
            child: Text(
              Strings.clearAll,
              style: FontPalette.base600(
                13,
                color: ColorPalette.formValidationErrorColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

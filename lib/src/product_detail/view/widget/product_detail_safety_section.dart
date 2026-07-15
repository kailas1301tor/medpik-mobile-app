// lib/src/product_detail/view/widget/product_detail_safety_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/product_detail/model/product_detail_model.dart';
import 'package:tsuite/utils/common_widgets/common_bottom_sheet.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';

class ProductDetailSafetySection extends StatelessWidget {
  const ProductDetailSafetySection({super.key, required this.detail});

  final ProductDetailModel detail;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (detail.safetyInformation.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.safetyInformation,
          style: FontPalette.base700(16, color: colors.primaryText),
        ),
        10.verticalSpace,
        GestureDetector(
          onTap: () => _showSafetySheet(context),
          behavior: HitTestBehavior.opaque,
          child: CommonContainer(
            padding: EdgeInsets.all(14.r),
            borderRadius: 12.r,
            color: colors.surface,
            border: Border.all(color: colors.inputBorder),
            child: Row(
              children: [
                Icon(
                  Icons.shield_outlined,
                  size: 20.r,
                  color: ColorPalette.productAccentTeal,
                ),
                10.horizontalSpace,
                Expanded(
                  child: Text(
                    detail.safetyInformation,
                    style: FontPalette.base400(
                      13,
                      color: colors.secondaryText,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20.r,
                  color: colors.secondaryText,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showSafetySheet(BuildContext context) {
    final colors = context.appColors;

    CommonBottomSheet.show(
      context: context,
      title: Strings.safetyInformation,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
        child: Text(
          detail.safetyInformation,
          style: FontPalette.base400(14, color: colors.secondaryText),
        ),
      ),
    );
  }
}

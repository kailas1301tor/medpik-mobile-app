// lib/src/product_detail/view/widget/product_detail_how_to_use_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/product_detail/model/product_detail_model.dart';

class ProductDetailHowToUseSection extends StatelessWidget {
  const ProductDetailHowToUseSection({super.key, required this.detail});

  final ProductDetailModel detail;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (detail.howToUse.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.howToUse,
          style: FontPalette.base700(16, color: colors.primaryText),
        ),
        10.verticalSpace,
        Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: colors.bannerInfoBg,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: colors.bannerInfoBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.assignment_outlined,
                size: 20.r,
                color: ColorPalette.productAccentTeal,
              ),
              10.horizontalSpace,
              Expanded(
                child: Text(
                  detail.howToUse,
                  style: FontPalette.base400(13, color: colors.secondaryText),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

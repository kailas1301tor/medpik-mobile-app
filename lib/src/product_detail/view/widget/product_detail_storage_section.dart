// lib/src/product_detail/view/widget/product_detail_storage_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';

class ProductDetailStorageSection extends StatelessWidget {
  const ProductDetailStorageSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.storageAndHandling,
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
                Icons.inventory_2_outlined,
                size: 20.r,
                color: ColorPalette.productAccentTeal,
              ),
              10.horizontalSpace,
              Expanded(
                child: Text(
                  Strings.genericStorageBody,
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

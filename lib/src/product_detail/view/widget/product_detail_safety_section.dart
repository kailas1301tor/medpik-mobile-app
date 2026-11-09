// lib/src/product_detail/view/widget/product_detail_safety_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/utils/helpers/product_detail_content_resolver.dart';

class ProductDetailSafetySection extends StatelessWidget {
  const ProductDetailSafetySection({
    super.key,
    required this.safetyBlocks,
  });

  final List<ProductDetailSafetyBlock> safetyBlocks;

  @override
  Widget build(BuildContext context) {
    if (safetyBlocks.isEmpty) return const SizedBox.shrink();

    final colors = context.appColors;
    final showSectionTitle = safetyBlocks.length > 1 ||
        safetyBlocks.first.title != Strings.safetyInformation;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showSectionTitle) ...[
          Text(
            Strings.safetyInformation,
            style: FontPalette.base700(16, color: colors.primaryText),
          ),
          10.verticalSpace,
        ],
        ...List.generate(safetyBlocks.length, (index) {
          final block = safetyBlocks[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == safetyBlocks.length - 1 ? 0 : 12.h,
            ),
            child: _SafetyCard(
              title: showSectionTitle ? block.title : Strings.safetyInformation,
              body: block.body,
              showInnerTitle: showSectionTitle,
            ),
          );
        }),
      ],
    );
  }
}

class _SafetyCard extends StatelessWidget {
  const _SafetyCard({
    required this.title,
    required this.body,
    required this.showInnerTitle,
  });

  final String title;
  final String body;
  final bool showInnerTitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: colors.bannerInfoBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.bannerInfoBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.shield_outlined,
                size: 20.r,
                color: ColorPalette.productAccentTeal,
              ),
              10.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showInnerTitle) ...[
                      Text(
                        title,
                        style: FontPalette.base600(
                          13,
                          color: colors.primaryText,
                        ),
                      ),
                      6.verticalSpace,
                    ],
                    Text(
                      body,
                      style: FontPalette.base400(
                        13,
                        color: colors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

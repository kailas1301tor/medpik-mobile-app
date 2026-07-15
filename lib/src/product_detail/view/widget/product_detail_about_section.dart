// lib/src/product_detail/view/widget/product_detail_about_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/product_detail/model/product_detail_model.dart';

class ProductDetailAboutSection extends StatelessWidget {
  const ProductDetailAboutSection({super.key, required this.detail});

  final ProductDetailModel detail;

  @override
  Widget build(BuildContext context) {
    if (detail.aboutText.isEmpty) {
      return const SizedBox.shrink();
    }

    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.aboutThisMedicine,
          style: FontPalette.base700(16, color: colors.primaryText),
        ),
        10.verticalSpace,
        _ExpandableAboutText(text: detail.aboutText),
      ],
    );
  }
}

class _ExpandableAboutText extends StatefulWidget {
  const _ExpandableAboutText({required this.text});

  final String text;

  @override
  State<_ExpandableAboutText> createState() => _ExpandableAboutTextState();
}

class _ExpandableAboutTextState extends State<_ExpandableAboutText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          style: FontPalette.base400(14, color: colors.secondaryText),
          maxLines: _expanded ? null : 3,
          overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        6.verticalSpace,
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _expanded ? Strings.readLess : Strings.readMore,
                style: FontPalette.base600(
                  13,
                  color: ColorPalette.productAccentTeal,
                ),
              ),
              4.horizontalSpace,
              Icon(
                _expanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                size: 18.r,
                color: ColorPalette.productAccentTeal,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

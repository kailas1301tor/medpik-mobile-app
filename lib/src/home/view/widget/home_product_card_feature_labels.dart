// lib/src/home/view/widget/home_product_card_feature_labels.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';

class HomeProductCardFeatureLabels extends StatelessWidget {
  const HomeProductCardFeatureLabels({super.key});

  @override
  Widget build(BuildContext context) {
    const labels = [
      Strings.painRelief,
      Strings.feverReducer,
      Strings.fastActing,
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final label in labels) ...[
          _FeatureLabel(text: label),
          if (label != labels.last) 6.verticalSpace,
        ],
      ],
    );
  }
}

class _FeatureLabel extends StatelessWidget {
  const _FeatureLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14.r,
          height: 14.r,
          decoration: BoxDecoration(
            color: colors.statusNeutralBg,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.circle,
            size: 6.r,
            color: colors.statusNeutralText,
          ),
        ),
        4.horizontalSpace,
        Text(
          text,
          style: FontPalette.base400(9, color: colors.statusNeutralText),
        ),
      ],
    );
  }
}

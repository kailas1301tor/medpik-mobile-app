// lib/src/orders/view/widget/order_product_preview_row.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/utils/common_widgets/common_cached_network_image.dart';

class OrderProductPreviewRow extends StatelessWidget {
  const OrderProductPreviewRow({super.key, required this.imageUrls});

  final List<String> imageUrls;

  static const int _maxVisible = 3;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    if (imageUrls.isEmpty) return const SizedBox.shrink();

    final visibleUrls = imageUrls.take(_maxVisible).toList();
    final overflowCount = imageUrls.length - _maxVisible;
    final thumbSize = 40.r;

    return Row(
      children: [
        for (var i = 0; i < visibleUrls.length; i++) ...[
          if (i > 0) 6.horizontalSpace,
          CommonCachedNetworkImage(
            imageUrl: visibleUrls[i],
            width: thumbSize,
            height: thumbSize,
            borderRadius: 10.r,
            fit: BoxFit.cover,
          ),
        ],
        if (overflowCount > 0) ...[
          6.horizontalSpace,
          Container(
            width: thumbSize,
            height: thumbSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.background.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: colors.cardBorder.withValues(alpha: 0.35),
                width: 1.w,
              ),
            ),
            child: Text(
              Strings.moreItemsCount(overflowCount),
              style: FontPalette.base600(10, color: colors.primary),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }
}

// lib/src/orders/view/widget/order_product_preview_row.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/utils/common_widgets/common_cached_network_image.dart';

class OrderProductPreviewRow extends StatelessWidget {
  const OrderProductPreviewRow({
    super.key,
    required this.imageUrls,
  });

  final List<String> imageUrls;

  static const int _maxVisible = 4;

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
            borderRadius: 8.r,
            fit: BoxFit.cover,
            memCacheWidth: 80,
            memCacheHeight: 80,
          ),
        ],
        if (overflowCount > 0) ...[
          6.horizontalSpace,
          SmoothContainer(
            smoothness: 1,
            width: thumbSize,
            height: thumbSize,
            color: colors.statusNeutralBg,
            borderRadius: BorderRadius.circular(8.r),
            alignment: Alignment.center,
            child: Text(
              '+$overflowCount',
              style: FontPalette.base600(12, color: colors.statusNeutralText),
            ),
          ),
        ],
      ],
    );
  }
}

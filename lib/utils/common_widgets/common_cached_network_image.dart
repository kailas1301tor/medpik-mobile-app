// /Users/wac/Documents/wac projects/tsuite/lib/utils/common_widgets/common_cached_network_image.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/utils/common_widgets/common_shimmer_box.dart';

class CommonCachedNetworkImage extends StatelessWidget {
  const CommonCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.memCacheWidth,
    this.memCacheHeight,
  });

  final String? imageUrl;
  final double? width;
  final double? height;
  final double? borderRadius;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final int? memCacheWidth;
  final int? memCacheHeight;

  @override
  Widget build(BuildContext context) {
    final effectivePlaceholder =
        placeholder ??
        CommonShimmerBox(
          width: width,
          height: height ?? 80.h,
          borderRadius: borderRadius ?? 16.r,
        );

    final fallback =
        errorWidget ??
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: context.appColors.inputBackground,
            borderRadius: BorderRadius.circular((borderRadius ?? 16).r),
          ),
          child: Icon(
            Icons.image_outlined,
            size: 24.r,
            color: ColorPalette.f808080,
          ),
        );

    if (imageUrl == null || imageUrl!.trim().isEmpty) {
      return fallback;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular((borderRadius ?? 16).r),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        memCacheWidth: memCacheWidth,
        memCacheHeight: memCacheHeight,
        placeholder: (_, __) => effectivePlaceholder,
        errorWidget: (_, __, ___) => fallback,
      ),
    );
  }
}

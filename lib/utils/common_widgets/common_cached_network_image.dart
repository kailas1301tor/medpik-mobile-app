// /Users/wac/Documents/wac projects/tsuite/lib/utils/common_widgets/common_cached_network_image.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_corner/smooth_corner.dart';
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
        SmoothContainer(
          width: width,
          height: height,
          smoothness: 2,
          borderRadius: BorderRadius.circular((borderRadius ?? 16).r),
          color: context.appColors.inputBackground,
          child: Icon(
            Icons.image_outlined,
            size: 24.r,
            color: ColorPalette.f808080,
          ),
        );

    if (imageUrl == null || imageUrl!.trim().isEmpty) {
      return fallback;
    }

    return SmoothClipRRect(
      smoothness: 2,
      side: BorderSide(
        color: ColorPalette.grey.withValues(alpha: 0.2),
        width: 1.w,
      ),
      borderRadius: BorderRadius.circular((borderRadius ?? 16).r),
      child: CachedNetworkImage(
        imageUrl: imageUrl ?? "",
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

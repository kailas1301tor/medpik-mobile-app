// lib/utils/common_widgets/common_cached_network_image.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:medpik/res/constants/medpik_image_assets.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/utils/common_widgets/common_shimmer_box.dart';
import 'package:medpik/utils/helpers/app_image_cache_manager.dart';
import 'package:medpik/utils/helpers/image_mem_cache_helper.dart';
import 'package:medpik/utils/helpers/pre_cache_images.dart';

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
    this.memCacheMax = 300,
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
  final int memCacheMax;

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
        CommonAssetPlaceholderImage(
          assetPath: MedpikImageAssets.productPlaceholder,
          width: width,
          height: height,
          borderRadius: borderRadius,
          fit: fit,
        );

    final normalizedUrl = imageUrl?.trim();
    if (normalizedUrl == null || normalizedUrl.isEmpty) {
      return fallback;
    }

    final cacheKey = AppImageCacheManager.cacheKeyFor(normalizedUrl);
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final resolvedMemCache = ImageMemCacheHelper.resolve(
      logicalWidth: width,
      logicalHeight: height,
      devicePixelRatio: dpr,
      fallbackLogicalWidth: MediaQuery.sizeOf(context).width,
      max: memCacheMax,
    );
    final effectiveMemCacheWidth = memCacheWidth ?? resolvedMemCache.width;
    final effectiveMemCacheHeight = memCacheHeight ?? resolvedMemCache.height;

    return RepaintBoundary(
      child: SmoothClipRRect(
        smoothness: 2,
        side: BorderSide(
          color: ColorPalette.grey.withValues(alpha: 0.2),
          width: 1.w,
        ),
        borderRadius: BorderRadius.circular((borderRadius ?? 16).r),
        child: SizedBox(
          width: width,
          height: height,
          child: CachedNetworkImage(
            imageUrl: normalizedUrl,
            cacheKey: cacheKey,
            cacheManager: AppImageCacheManager.instance,
            width: width,
            height: height,
            fit: fit,
            memCacheWidth: effectiveMemCacheWidth,
            memCacheHeight: effectiveMemCacheHeight,
            fadeInDuration: const Duration(milliseconds: 120),
            fadeOutDuration: Duration.zero,
            useOldImageOnUrlChange: true,
            filterQuality: FilterQuality.low,
            placeholder: (context, url) => effectivePlaceholder,
            errorWidget: (context, url, error) => fallback,
          ),
        ),
      ),
    );
  }
}

class CommonNetworkImageIconFallback extends StatelessWidget {
  const CommonNetworkImageIconFallback({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  final double? width;
  final double? height;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return SmoothContainer(
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
  }
}

class CommonAssetPlaceholderImage extends StatelessWidget {
  const CommonAssetPlaceholderImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
  });

  final String assetPath;
  final double? width;
  final double? height;
  final double? borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final precachedProvider = PreCacheImages.providerFor(assetPath);

    return SmoothClipRRect(
      smoothness: 2,
      borderRadius: BorderRadius.circular((borderRadius ?? 16).r),
      child: precachedProvider == null
          ? Image.asset(
              assetPath,
              width: width,
              height: height,
              fit: fit,
              gaplessPlayback: true,
            )
          : Image(
              image: precachedProvider,
              width: width,
              height: height,
              fit: fit,
              gaplessPlayback: true,
            ),
    );
  }
}

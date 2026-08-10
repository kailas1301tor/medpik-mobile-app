// lib/utils/common_widgets/common_cached_network_image.dart
import 'dart:io';

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

class CommonCachedNetworkImage extends StatefulWidget {
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
  State<CommonCachedNetworkImage> createState() =>
      _CommonCachedNetworkImageState();
}

class _CommonCachedNetworkImageState extends State<CommonCachedNetworkImage> {
  File? _diskFile;
  bool _diskLookupComplete = false;

  @override
  void initState() {
    super.initState();
    _probeDiskCache();
  }

  @override
  void didUpdateWidget(covariant CommonCachedNetworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl?.trim() != widget.imageUrl?.trim()) {
      _diskFile = null;
      _diskLookupComplete = false;
      _probeDiskCache();
    }
  }

  Future<void> _probeDiskCache() async {
    final normalizedUrl = widget.imageUrl?.trim();
    if (normalizedUrl == null || normalizedUrl.isEmpty) {
      if (mounted) {
        setState(() => _diskLookupComplete = true);
      }
      return;
    }

    final cacheKey = AppImageCacheManager.cacheKeyFor(normalizedUrl);
    final cached = await AppImageCacheManager.instance.getFileFromCache(
      cacheKey,
    );

    if (!mounted) return;
    setState(() {
      _diskFile = cached?.file;
      _diskLookupComplete = true;
      if (_diskFile != null) {
        AppImageWarmCache.markWarmed(normalizedUrl);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final effectivePlaceholder =
        widget.placeholder ??
        CommonShimmerBox(
          width: widget.width,
          height: widget.height ?? 80.h,
          borderRadius: widget.borderRadius ?? 16.r,
        );

    final fallback =
        widget.errorWidget ??
        CommonAssetPlaceholderImage(
          assetPath: MedpikImageAssets.productPlaceholder,
          width: widget.width,
          height: widget.height,
          borderRadius: widget.borderRadius,
          fit: widget.fit,
        );

    final normalizedUrl = widget.imageUrl?.trim();
    if (normalizedUrl == null || normalizedUrl.isEmpty) {
      return fallback;
    }

    final cacheKey = AppImageCacheManager.cacheKeyFor(normalizedUrl);
    final isWarmed = AppImageWarmCache.isWarmed(normalizedUrl);
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final resolvedMemCache = ImageMemCacheHelper.resolve(
      logicalWidth: widget.width,
      logicalHeight: widget.height,
      devicePixelRatio: dpr,
      fallbackLogicalWidth: MediaQuery.sizeOf(context).width,
      max: widget.memCacheMax,
    );
    final effectiveMemCacheWidth =
        widget.memCacheWidth ?? resolvedMemCache.width;
    final effectiveMemCacheHeight =
        widget.memCacheHeight ?? resolvedMemCache.height;

    return RepaintBoundary(
      child: SmoothClipRRect(
        smoothness: 2,
        side: BorderSide(
          color: ColorPalette.grey.withValues(alpha: 0.2),
          width: 1.w,
        ),
        borderRadius: BorderRadius.circular((widget.borderRadius ?? 16).r),
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _LoadingSlot(
                width: widget.width,
                height: widget.height,
                showShimmer:
                    !isWarmed &&
                    _diskLookupComplete &&
                    _diskFile == null,
                placeholder: effectivePlaceholder,
              ),
              if (_diskFile != null)
                Image.file(
                  _diskFile!,
                  fit: widget.fit,
                  gaplessPlayback: true,
                  filterQuality: FilterQuality.low,
                  cacheWidth: effectiveMemCacheWidth,
                  cacheHeight: effectiveMemCacheHeight,
                  errorBuilder: (_, __, ___) => fallback,
                )
              else if (_diskLookupComplete)
                Image(
                  image: CachedNetworkImageProvider(
                    normalizedUrl,
                    cacheKey: cacheKey,
                    cacheManager: AppImageCacheManager.instance,
                    maxWidth: effectiveMemCacheWidth,
                    maxHeight: effectiveMemCacheHeight,
                  ),
                  fit: widget.fit,
                  gaplessPlayback: true,
                  filterQuality: FilterQuality.low,
                  frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded || frame != null) {
                      AppImageWarmCache.markWarmed(normalizedUrl);
                      return child;
                    }
                    return const SizedBox.shrink();
                  },
                  errorBuilder: (_, __, ___) => fallback,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingSlot extends StatelessWidget {
  const _LoadingSlot({
    required this.width,
    required this.height,
    required this.showShimmer,
    required this.placeholder,
  });

  final double? width;
  final double? height;
  final bool showShimmer;
  final Widget placeholder;

  @override
  Widget build(BuildContext context) {
    if (showShimmer) return placeholder;

    return ColoredBox(
      color: context.appColors.inputBackground,
      child: SizedBox(width: width, height: height),
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

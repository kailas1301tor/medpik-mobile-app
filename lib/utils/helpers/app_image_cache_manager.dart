// lib/utils/helpers/app_image_cache_manager.dart
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Shared disk + memory cache manager for all [CommonCachedNetworkImage] instances.
abstract final class AppImageCacheManager {
  static const _cacheKey = 'medpikNetworkImages';

  static final CacheManager instance = CacheManager(
    Config(
      _cacheKey,
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 800,
    ),
  );

  static String cacheKeyFor(String url) => url.trim();
}
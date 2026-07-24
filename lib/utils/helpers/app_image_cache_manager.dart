// lib/utils/helpers/app_image_cache_manager.dart
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Shared disk + memory cache for all [CommonCachedNetworkImage] instances.
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

/// URLs that have been displayed at least once this app session.
/// Prevents shimmer / reload flashes when list cells are recreated on scroll.
abstract final class AppImageWarmCache {
  static final Set<String> _warmedKeys = <String>{};

  static bool isWarmed(String url) => _warmedKeys.contains(cacheKeyFor(url));

  static void markWarmed(String url) {
    final key = cacheKeyFor(url);
    if (key.isEmpty) return;
    _warmedKeys.add(key);
  }

  static String cacheKeyFor(String url) => AppImageCacheManager.cacheKeyFor(url);
}

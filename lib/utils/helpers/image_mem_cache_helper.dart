// lib/utils/helpers/image_mem_cache_helper.dart

/// Resolves in-memory decode dimensions for network images from logical layout
/// size and device pixel ratio.
abstract final class ImageMemCacheHelper {
  static int dimension(
    double logical,
    double devicePixelRatio, {
    int min = 48,
    int max = 300,
  }) {
    if (!logical.isFinite || logical <= 0) {
      return max;
    }
    return (logical * devicePixelRatio).round().clamp(min, max);
  }

  static ({int? width, int? height}) resolve({
    required double? logicalWidth,
    required double? logicalHeight,
    required double devicePixelRatio,
    double? fallbackLogicalWidth,
    int min = 48,
    int max = 300,
  }) {
    final effectiveWidth = _effectiveLogical(
      logicalWidth,
      fallback: fallbackLogicalWidth,
    );
    final effectiveHeight = _effectiveLogical(logicalHeight);

    return (
      width: effectiveWidth == null
          ? null
          : dimension(
              effectiveWidth,
              devicePixelRatio,
              min: min,
              max: max,
            ),
      height: effectiveHeight == null
          ? null
          : dimension(
              effectiveHeight,
              devicePixelRatio,
              min: min,
              max: max,
            ),
    );
  }

  static double? _effectiveLogical(
    double? logical, {
    double? fallback,
  }) {
    if (logical != null && logical.isFinite && logical > 0) {
      return logical;
    }
    if (fallback != null && fallback.isFinite && fallback > 0) {
      return fallback;
    }
    return null;
  }
}

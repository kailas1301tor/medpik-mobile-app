// lib/utils/helpers/pagination_scroll_helper.dart
import 'package:flutter/material.dart';

/// Default distance from the bottom (logical px) that triggers the next page.
const double kPaginationNearBottomThreshold = 240;

/// Returns true when a vertical scrollable is near its end and another page
/// should be requested.
bool shouldLoadMoreFromScroll({
  required ScrollMetrics metrics,
  required bool hasMore,
  required bool isLoadingMore,
  double threshold = kPaginationNearBottomThreshold,
}) {
  if (!hasMore || isLoadingMore) return false;
  if (metrics.axis != Axis.vertical) return false;
  // Short content that cannot scroll still needs the next page when available.
  if (metrics.maxScrollExtent <= 0) return true;
  return metrics.extentAfter <= threshold;
}

/// Wraps [child] and invokes [onLoadMore] when the user scrolls near the bottom
/// (or when layout metrics show the viewport is underfilled and more pages exist).
///
/// Does not absorb notifications (returns false) so pull-to-refresh and nested
/// listeners keep working. Relies on the caller's notifier to guard against
/// duplicate in-flight fetches (`hasMore` / `isLoadingMore`).
class PaginationScrollListener extends StatelessWidget {
  const PaginationScrollListener({
    super.key,
    required this.hasMore,
    required this.isLoadingMore,
    required this.onLoadMore,
    required this.child,
    this.threshold = kPaginationNearBottomThreshold,
  });

  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;
  final Widget child;
  final double threshold;

  void _maybeLoad(ScrollMetrics metrics) {
    if (shouldLoadMoreFromScroll(
      metrics: metrics,
      hasMore: hasMore,
      isLoadingMore: isLoadingMore,
      threshold: threshold,
    )) {
      onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollMetricsNotification>(
      onNotification: (notification) {
        // First layout / size changes (fills short first pages without a drag).
        if (notification.depth != 0) return false;
        _maybeLoad(notification.metrics);
        return false;
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          final isRelevant =
              notification is ScrollUpdateNotification ||
              notification is ScrollEndNotification ||
              notification is OverscrollNotification;
          if (!isRelevant) return false;
          // Prefer the scrollable that owns this listener's subtree (depth 0).
          if (notification.depth != 0) return false;
          _maybeLoad(notification.metrics);
          return false;
        },
        child: child,
      ),
    );
  }
}

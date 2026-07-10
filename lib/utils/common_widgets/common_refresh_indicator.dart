import 'package:flutter/material.dart';

class CommonRefreshIndicator extends StatelessWidget {
  const CommonRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
    this.color,
    this.backgroundColor,
    this.displacement = 60.0,
    this.strokeWidth = 2.0,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.triggerMode = RefreshIndicatorTriggerMode.onEdge,
  });

  final Future<void> Function() onRefresh;
  final Widget child;
  final Color? color;
  final Color? backgroundColor;
  final double displacement;
  final double strokeWidth;
  final ScrollNotificationPredicate notificationPredicate;
  final RefreshIndicatorTriggerMode triggerMode;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return RefreshIndicator.adaptive(
      onRefresh: onRefresh,
      color: color ?? colorScheme.primary,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      displacement: displacement,
      strokeWidth: strokeWidth,
      notificationPredicate: notificationPredicate,
      triggerMode: triggerMode,
      child: child,
    );
  }
}

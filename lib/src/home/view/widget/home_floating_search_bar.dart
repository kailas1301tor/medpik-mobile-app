// lib/src/home/view/widget/home_floating_search_bar.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/src/home/notifier/home_notifier.dart';
import 'package:medpik/src/home/view/widget/home_header_shared.dart';
import 'package:tuple/tuple.dart';

/// Home search that crossfades between the banner slot and the compact slot.
///
/// Driven by [HomeState.compactHeaderProgress] + [HomeState.scrollOffset] so we
/// never read [ScrollController.offset] (which asserts a single attachment).
class HomeFloatingSearchBar extends ConsumerWidget {
  const HomeFloatingSearchBar({
    super.key,
    required this.topInset,
    required this.onSearchTap,
  });

  final double topInset;
  final VoidCallback onSearchTap;

  /// Must stay in sync with [HomeHeroHeader] height math.
  static double heroBodyHeight(BuildContext context) => 356.h;

  /// Must stay in sync with [HomeHeroHeader] inner padding.
  static double heroInnerPadding(BuildContext context) => 12.h;

  /// Must stay in sync with [CommonSearchBar] field height.
  static double searchHeight(BuildContext context) => 50.h;

  /// Must stay in sync with [HomeCompactHeader] location row + gap.
  static double compactLocationBlockHeight(BuildContext context) =>
      32.h + 10.h;

  static double _ease(double progress) =>
      Curves.easeInOutCubic.transform(progress.clamp(0.0, 1.0));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scroll = ref.watch(
      homeNotifierProvider.select(
        (s) => Tuple2(s.compactHeaderProgress, s.scrollOffset),
      ),
    );
    final progress = scroll.item1;
    final offset = scroll.item2;
    final t = _ease(progress);

    // Banner slot tracks the scrolling hero; compact slot stays pinned.
    final bannerTop =
        topInset +
        heroBodyHeight(context) -
        heroInnerPadding(context) -
        searchHeight(context) -
        offset;

    final compactSlide = lerpDouble(-16, 0, t) ?? 0;
    final compactTop =
        topInset + 8.h + compactLocationBlockHeight(context) + compactSlide;

    // Complementary fade — no travel through the middle of the banner.
    final bannerOpacity = (1.0 - t).clamp(0.0, 1.0);
    final compactOpacity = t.clamp(0.0, 1.0);

    return Stack(
      children: [
        if (bannerOpacity > 0.01)
          Positioned(
            top: bannerTop,
            left: 16.w,
            right: 16.w,
            child: IgnorePointer(
              ignoring: bannerOpacity < 0.5,
              child: Opacity(
                opacity: bannerOpacity,
                child: HomeHeaderSearchRow(onSearchTap: onSearchTap),
              ),
            ),
          ),
        if (compactOpacity > 0.01)
          Positioned(
            top: compactTop,
            left: 16.w,
            right: 16.w,
            child: IgnorePointer(
              ignoring: compactOpacity < 0.5,
              child: Opacity(
                opacity: compactOpacity,
                child: HomeHeaderSearchRow(onSearchTap: onSearchTap),
              ),
            ),
          ),
      ],
    );
  }
}

// lib/src/home/view/widget/home_compact_header.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/src/home/view/widget/home_header_shared.dart';

class HomeCompactHeader extends StatelessWidget {
  const HomeCompactHeader({
    super.key,
    required this.progress,
    required this.topInset,
    required this.deliveryHint,
    required this.searchController,
    required this.onSearchTap,
  });

  final double progress;
  final double topInset;
  final String deliveryHint;
  final TextEditingController searchController;
  final VoidCallback onSearchTap;

  @override
  Widget build(BuildContext context) {
    if (progress <= 0) return const SizedBox.shrink();

    final slideOffset = lerpDouble(-16, 0, progress)!;
    final shadowOpacity = progress * 0.12;

    return IgnorePointer(
      ignoring: progress < 0.35,
      child: Opacity(
        opacity: progress.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, slideOffset),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: ColorPalette.white,
              boxShadow: [
                BoxShadow(
                  color: ColorPalette.black.withValues(alpha: shadowOpacity),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                16.w,
                topInset + 8.h,
                16.w,
                10.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HomeHeaderLocationRow(deliveryHint: deliveryHint),
                  10.verticalSpace,
                  HomeHeaderSearchRow(
                    searchController: searchController,
                    onSearchTap: onSearchTap,
                    compact: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

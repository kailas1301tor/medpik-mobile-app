// lib/src/home/view/widget/home_promo_banner_carousel.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/utils/common_widgets/common_cached_network_image.dart';

class HomePromoBannerCarousel extends StatefulWidget {
  const HomePromoBannerCarousel({
    super.key,
    this.imageUrls = const [],
    this.height,
    this.autoPlayInterval = const Duration(seconds: 4),
  });

  /// Network banner URLs from the home API.
  final List<String> imageUrls;
  final double? height;
  final Duration autoPlayInterval;

  @override
  State<HomePromoBannerCarousel> createState() =>
      _HomePromoBannerCarouselState();
}

class _HomePromoBannerCarouselState extends State<HomePromoBannerCarousel> {
  late final PageController _pageController;
  Timer? _autoPlayTimer;
  int _currentPage = 0;
  bool _isUserInteracting = false;

  List<String> get _urls => widget.imageUrls
      .map((u) => u.trim())
      .where((u) => u.isNotEmpty)
      .toList(growable: false);

  int get _itemCount => _urls.length;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.92);
    _restartAutoPlay();
  }

  @override
  void didUpdateWidget(covariant HomePromoBannerCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrls != widget.imageUrls ||
        oldWidget.autoPlayInterval != widget.autoPlayInterval) {
      _currentPage = 0;
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
      _restartAutoPlay();
    }
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _restartAutoPlay() {
    _autoPlayTimer?.cancel();
    if (_itemCount <= 1) return;
    _autoPlayTimer = Timer.periodic(widget.autoPlayInterval, (_) {
      if (!mounted || _isUserInteracting || !_pageController.hasClients) {
        return;
      }
      final next = (_currentPage + 1) % _itemCount;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_itemCount == 0) return const SizedBox.shrink();

    final height = widget.height ?? 148.h;
    final colors = context.appColors;
    final radius = 20.r;

    return Column(
      children: [
        SizedBox(
          height: height,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollStartNotification &&
                  notification.dragDetails != null) {
                _isUserInteracting = true;
              } else if (notification is ScrollEndNotification) {
                _isUserInteracting = false;
              }
              return false;
            },
            child: PageView.builder(
              controller: _pageController,
              itemCount: _itemCount,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(radius),
                    child: CommonCachedNetworkImage(
                      imageUrl: _urls[index],
                      width: double.infinity,
                      height: height,
                      fit: BoxFit.cover,
                      borderRadius: 20,
                      showBorder: false,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (_itemCount > 1) ...[
          10.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_itemCount, (index) {
              final isActive = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                width: isActive ? 16.w : 6.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: isActive
                      ? ColorPalette.primaryColor
                      : colors.divider.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(999.r),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}

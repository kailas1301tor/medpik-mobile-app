// lib/src/home/view/widget/home_offer_carousel.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/home/model/home_model.dart';
import 'package:tsuite/utils/helpers/hex_color_helper.dart';

class HomeOfferCarousel extends StatefulWidget {
  const HomeOfferCarousel({super.key, required this.offers});

  final List<OfferModel> offers;

  @override
  State<HomeOfferCarousel> createState() => _HomeOfferCarouselState();
}

class _HomeOfferCarouselState extends State<HomeOfferCarousel> {
  static const _autoScrollInterval = Duration(seconds: 4);
  static const _pageAnimationDuration = Duration(milliseconds: 400);
  static const _resumeDelayAfterInteraction = Duration(seconds: 3);
  static const _virtualPageCount = 10000;
  static const _recenterThreshold = 100;

  late final PageController _pageController;
  Timer? _autoScrollTimer;
  Timer? _resumeTimer;
  late int _virtualPage;
  int _activeOfferIndex = 0;
  bool _isUserScrolling = false;

  int _initialVirtualPage(int offersLength) {
    if (offersLength <= 1) return 0;
    final middle = _virtualPageCount ~/ 2;
    return middle - (middle % offersLength);
  }

  @override
  void initState() {
    super.initState();
    final offersLength = widget.offers.length;
    _virtualPage = _initialVirtualPage(offersLength);
    _pageController = PageController(initialPage: _virtualPage);
    _pageController.addListener(_onPageChanged);
    _startAutoScroll();
  }

  @override
  void didUpdateWidget(covariant HomeOfferCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.offers.length == widget.offers.length) return;

    final offersLength = widget.offers.length;
    _virtualPage = _initialVirtualPage(offersLength);
    _activeOfferIndex = 0;

    if (_pageController.hasClients) {
      _pageController.jumpToPage(_virtualPage);
    }

    _stopAutoScroll();
    _cancelResumeTimer();
    _startAutoScroll();
  }

  void _onPageChanged() {
    if (!_pageController.hasClients) return;

    final page = _pageController.page?.round() ?? _virtualPage;
    final offersLength = widget.offers.length;
    if (offersLength <= 1) return;

    final activeIndex = page % offersLength;
    if (page != _virtualPage || activeIndex != _activeOfferIndex) {
      setState(() {
        _virtualPage = page;
        _activeOfferIndex = activeIndex;
      });
    }
  }

  void _maybeRecenter(int page) {
    final offersLength = widget.offers.length;
    if (offersLength <= 1 || !_pageController.hasClients) return;

    if (page < _recenterThreshold || page > _virtualPageCount - _recenterThreshold) {
      final realIndex = page % offersLength;
      final newPage = _initialVirtualPage(offersLength) + realIndex;
      if (_pageController.page?.round() != newPage) {
        _pageController.jumpToPage(newPage);
        _virtualPage = newPage;
        _activeOfferIndex = realIndex;
      }
    }
  }

  void _startAutoScroll() {
    if (widget.offers.length <= 1) return;

    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(_autoScrollInterval, (_) {
      _advanceToNextPage();
    });
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
  }

  void _cancelResumeTimer() {
    _resumeTimer?.cancel();
    _resumeTimer = null;
  }

  void _scheduleResumeAutoScroll() {
    _cancelResumeTimer();
    _resumeTimer = Timer(_resumeDelayAfterInteraction, () {
      if (!mounted) return;
      _isUserScrolling = false;
      _startAutoScroll();
    });
  }

  void _advanceToNextPage() {
    if (!mounted || _isUserScrolling || !_pageController.hasClients) return;

    final offersLength = widget.offers.length;
    if (offersLength <= 1) return;

    final currentPage = _pageController.page?.round() ?? _virtualPage;
    final nextPage = currentPage + 1;

    _pageController
        .animateToPage(
          nextPage,
          duration: _pageAnimationDuration,
          curve: Curves.easeInOut,
        )
        .then((_) {
          if (!mounted) return;
          _maybeRecenter(nextPage);
        });
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification &&
        notification.dragDetails != null) {
      _isUserScrolling = true;
      _stopAutoScroll();
      _cancelResumeTimer();
    } else if (notification is ScrollEndNotification) {
      final page = _pageController.page?.round() ?? _virtualPage;
      _maybeRecenter(page);

      if (_isUserScrolling) {
        _scheduleResumeAutoScroll();
      }
    }
    return false;
  }

  @override
  void dispose() {
    _stopAutoScroll();
    _cancelResumeTimer();
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    super.dispose();
  }

  LinearGradient _gradientFor(OfferModel offer, int index) {
    final start = tryParseHexColor(offer.gradientColor1);
    final end = tryParseHexColor(offer.gradientColor2);
    if (start != null && end != null) {
      // Admin-style horizontal blend (same as CSS linear-gradient(to right, …)).
      return LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [start, end],
        stops: const [0.0, 1.0],
      );
    }

    return switch (index % 5) {
      0 => ColorPalette.offerLimeMagenta,
      1 => ColorPalette.offerSlateSilver,
      2 => ColorPalette.offerInkPurple,
      3 => ColorPalette.offerRedBlue,
      _ => ColorPalette.offerForestTeal,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final offers = widget.offers;
    final offersLength = offers.length;

    if (offers.isEmpty) return const SizedBox.shrink();

    final itemCount = offersLength > 1 ? _virtualPageCount : offersLength;

    return Column(
      children: [
        SizedBox(
          height: 160.h,
          child: NotificationListener<ScrollNotification>(
            onNotification: _onScrollNotification,
            child: PageView.builder(
              controller: _pageController,
              itemCount: itemCount,
              itemBuilder: (context, index) {
                final offerIndex = index % offersLength;
                final offer = offers[offerIndex];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: _OfferBannerCard(
                    offer: offer,
                    gradient: _gradientFor(offer, offerIndex),
                  ),
                );
              },
            ),
          ),
        ),
        8.verticalSpace,
        if (offersLength > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(offersLength, (index) {
              final isActive = index == _activeOfferIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                width: isActive ? 18.w : 6.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: isActive ? colors.primary : colors.inputBorder,
                  borderRadius: BorderRadius.circular(999.r),
                ),
              );
            }),
          ),
      ],
    );
  }
}

class _OfferBannerCard extends StatelessWidget {
  const _OfferBannerCard({required this.offer, required this.gradient});

  final OfferModel offer;
  final LinearGradient gradient;

  @override
  Widget build(BuildContext context) {
    return SmoothClipRRect(
      smoothness: 2,
      borderRadius: BorderRadius.circular(20.r),
      child: DecoratedBox(
        decoration: BoxDecoration(gradient: gradient),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (offer.badgeLabel?.isNotEmpty ?? false)
                SmoothContainer(
                  smoothness: 2,
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  color: ColorPalette.white.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(999.r),
                  child: Text(
                    offer.badgeLabel!,
                    style: FontPalette.base700(
                      9,
                      color: ColorPalette.white,
                    ),
                  ),
                ),
              8.verticalSpace,
              Text(
                offer.title,
                style: FontPalette.base700(20, color: ColorPalette.white),
              ),
              4.verticalSpace,
              Text(
                offer.subtitle,
                style: FontPalette.base400(
                  12,
                  color: ColorPalette.white.withValues(alpha: 0.9),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (offer.promoCode?.isNotEmpty ?? false) ...[
                8.verticalSpace,
                SmoothContainer(
                  smoothness: 2,
                  color: ColorPalette.white.withValues(alpha: 0.2),
                  side: BorderSide(
                    color: ColorPalette.white.withValues(alpha: 0.45),
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  child: Text(
                    '${Strings.useCode} ${offer.promoCode}',
                    style: FontPalette.base600(11, color: ColorPalette.white),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

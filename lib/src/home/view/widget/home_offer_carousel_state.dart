// lib/src/home/view/widget/home_offer_carousel_state.dart
part of 'home_offer_carousel.dart';

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

  @override
  void dispose() {
    _disposeAutoScroll();
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    super.dispose();
  }

  LinearGradient _gradientFor(OfferModel offer, int index) {
    final start = tryParseHexColor(offer.gradientColor1);
    final end = tryParseHexColor(offer.gradientColor2);
    if (start != null && end != null) {
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
    final offers = widget.offers;
    final offersLength = offers.length;
    final onOfferTap = widget.onOfferTap;

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
                    onTap: onOfferTap == null ? null : () => onOfferTap(offer),
                  ),
                );
              },
            ),
          ),
        ),
        8.verticalSpace,
        if (offersLength > 1)
          _OfferCarouselIndicators(
            count: offersLength,
            activeIndex: _activeOfferIndex,
          ),
      ],
    );
  }
}

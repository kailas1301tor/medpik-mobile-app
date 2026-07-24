// lib/src/home/view/widget/home_offer_carousel_autoscroll.dart
part of 'home_offer_carousel.dart';

extension _HomeOfferCarouselAutoScroll on _HomeOfferCarouselState {
  void _maybeRecenter(int page) {
    final offersLength = widget.offers.length;
    if (offersLength <= 1 || !_pageController.hasClients) return;

    if (page < _HomeOfferCarouselState._recenterThreshold ||
        page >
            _HomeOfferCarouselState._virtualPageCount -
                _HomeOfferCarouselState._recenterThreshold) {
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
    _autoScrollTimer = Timer.periodic(_HomeOfferCarouselState._autoScrollInterval, (_) {
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
    _resumeTimer = Timer(_HomeOfferCarouselState._resumeDelayAfterInteraction, () {
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
          duration: _HomeOfferCarouselState._pageAnimationDuration,
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

  void _disposeAutoScroll() {
    _stopAutoScroll();
    _cancelResumeTimer();
  }
}

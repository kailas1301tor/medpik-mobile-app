// lib/src/home/view/widget/home_offer_carousel_indicators.dart
part of 'home_offer_carousel.dart';

class _OfferCarouselIndicators extends StatelessWidget {
  const _OfferCarouselIndicators({
    required this.count,
    required this.activeIndex,
  });

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
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
    );
  }
}

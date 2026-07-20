// lib/src/home/view/widget/home_offer_carousel_banner_card.dart
part of 'home_offer_carousel.dart';

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

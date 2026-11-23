// lib/src/home/view/widget/home_offer_carousel_banner_card.dart
part of 'home_offer_carousel.dart';

class _OfferBannerCard extends StatelessWidget {
  const _OfferBannerCard({
    required this.offer,
    required this.fallbackColor,
    this.onTap,
  });

  final OfferModel offer;
  final Color fallbackColor;
  final VoidCallback? onTap;

  bool get _hasImage => offer.imageUrl.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SmoothClipRRect(
        smoothness: 2,
        borderRadius: BorderRadius.circular(20.r),
        child: _hasImage
            ? _OfferImageCard(imageUrl: offer.imageUrl.trim())
            : _OfferTextCard(offer: offer, color: fallbackColor),
      ),
    );
  }
}

class _OfferImageCard extends StatelessWidget {
  const _OfferImageCard({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dpr = MediaQuery.devicePixelRatioOf(context);
        final decode = ImageMemCacheHelper.bannerDecodeSize(
          logicalWidth: constraints.maxWidth,
          logicalHeight: constraints.maxHeight,
          devicePixelRatio: dpr,
        );
        return CommonCachedNetworkImage(
          imageUrl: imageUrl,
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          fit: BoxFit.cover,
          borderRadius: 20,
          showBorder: false,
          memCacheWidth: decode.width,
          memCacheHeight: decode.height,
          filterQuality: FilterQuality.medium,
        );
      },
    );
  }
}

class _OfferTextCard extends StatelessWidget {
  const _OfferTextCard({
    required this.offer,
    required this.color,
  });

  final OfferModel offer;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color,
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            8.verticalSpace,
            Text(
              offer.title,
              style: FontPalette.base700(20, color: ColorPalette.white),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

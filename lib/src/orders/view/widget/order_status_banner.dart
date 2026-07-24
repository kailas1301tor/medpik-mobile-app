// lib/src/orders/view/widget/order_status_banner.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/utils/common_widgets/common_container.dart';
import 'package:medpik/utils/helpers/order_status_helper.dart';

class OrderStatusBanner extends StatelessWidget {
  const OrderStatusBanner({
    super.key,
    required this.data,
    this.onTap,
  });

  final OrderStatusBannerData data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final (bg, border, titleColor) = _bannerColors(data.type, colors);

    return CommonContainer(
      padding: EdgeInsets.all(14.r),
      borderRadius: 12.r,
      color: bg,
      border: Border.all(color: border),
      onTap: data.isTappable ? onTap : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(data.icon, size: 22.r, color: titleColor),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: FontPalette.base600(14, color: titleColor),
                ),
                if (data.subtitle?.isNotEmpty ?? false) ...[
                  4.verticalSpace,
                  Text(
                    data.subtitle ?? '',
                    style: FontPalette.base400(12, color: colors.secondaryText),
                  ),
                ],
              ],
            ),
          ),
          if (data.isTappable) ...[
            8.horizontalSpace,
            Icon(
              Icons.chevron_right_rounded,
              size: 20.r,
              color: colors.secondaryText,
            ),
          ],
        ],
      ),
    );
  }

  (Color, Color, Color) _bannerColors(OrderStatusBannerType type, AppColors colors) {
    return switch (type) {
      OrderStatusBannerType.delivery => (
          colors.bannerSuccessBg,
          colors.bannerSuccessBorder,
          colors.statusSuccessText,
        ),
      OrderStatusBannerType.rejection => (
          colors.bannerErrorBg,
          colors.bannerErrorBorder,
          colors.statusErrorText,
        ),
      OrderStatusBannerType.billGenerated => (
          colors.bannerInfoBg,
          colors.bannerInfoBorder,
          colors.primaryText,
        ),
      OrderStatusBannerType.billReview => (
          colors.bannerWarningBg,
          colors.bannerWarningBorder,
          colors.statusWarningText,
        ),
      OrderStatusBannerType.billAccepted => (
          colors.bannerSuccessBg,
          colors.bannerSuccessBorder,
          colors.statusSuccessText,
        ),
      OrderStatusBannerType.securePayment => (
          colors.bannerSecureBg,
          colors.bannerSecureBorder,
          colors.statusInfoText,
        ),
      OrderStatusBannerType.none => (
          colors.surface,
          colors.inputBorder,
          colors.primaryText,
        ),
    };
  }
}

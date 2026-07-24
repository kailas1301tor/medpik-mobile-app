// lib/src/orders/view/widget/order_detail_bottom_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/data/models/order_model.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/utils/common_widgets/common_sticky_bottom_bar.dart';
import 'package:medpik/utils/common_widgets/primary_button.dart';
import 'package:medpik/utils/extensions/num_extensions.dart';
import 'package:medpik/utils/helpers/order_status_helper.dart';

class OrderDetailBottomBar extends StatelessWidget {
  const OrderDetailBottomBar({
    super.key,
    required this.order,
    required this.onCtaPressed,
  });

  final OrderModel order;
  final VoidCallback onCtaPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final cta = orderDetailPrimaryCta(order.status);
    final showTotal = orderStatusShowsTotal(order.status) &&
        order.hasKnownAmount &&
        order.displayGrandTotal > 0;

    return CommonStickyBottomBar(
      child: Row(
        children: [
          if (showTotal)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    Strings.totalAmount,
                    style: FontPalette.base400(12, color: colors.secondaryText),
                  ),
                  2.verticalSpace,
                  Text(
                    order.displayGrandTotal.toCurrency(decimalDigits: 0),
                    style: FontPalette.base700(20, color: colors.primaryText),
                  ),
                ],
              ),
            ),
          if (cta != null) ...[
            if (showTotal) 12.horizontalSpace,
            Expanded(
              flex: showTotal ? 1 : 2,
              child: PrimaryButton(
                text: cta.label,
                height: 48.h,
                backgroundColor: cta.isOutlined ? colors.surface : null,
                textColor: cta.isOutlined ? colors.primary : ColorPalette.white,
                borderSide: cta.isOutlined
                    ? BorderSide(color: colors.primary, width: 1.5.w)
                    : null,
                onPressed: onCtaPressed,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

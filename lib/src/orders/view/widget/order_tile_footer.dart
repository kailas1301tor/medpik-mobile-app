// lib/src/orders/view/widget/order_tile_footer.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/data/models/order_model.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/utils/extensions/num_extensions.dart';
import 'package:medpik/utils/helpers/order_status_helper.dart';

class OrderTileFooter extends StatelessWidget {
  const OrderTileFooter({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final showTotal =
        orderStatusShowsTotal(order.status) &&
        order.hasKnownAmount &&
        order.amount > 0;

    return Row(
      children: [
        _FooterPill(
          label: orderCardCountLabel(order),
          background: colors.background.withValues(alpha: 0.7),
          textColor: colors.primaryText,
        ),
        if (order.hasPrescription) ...[
          6.horizontalSpace,
          _FooterPill(
            label: Strings.prescriptionOrder,
            background: colors.primary.withValues(alpha: 0.1),
            textColor: colors.primary,
          ),
        ],
        const Spacer(),
        if (showTotal)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                Strings.totalLabel,
                style: FontPalette.base400(10, color: colors.secondaryText),
              ),
              Text(
                order.amount.toCurrency(decimalDigits: 0),
                style: FontPalette.base700(13, color: colors.primaryText),
              ),
            ],
          ),
      ],
    );
  }
}

class _FooterPill extends StatelessWidget {
  const _FooterPill({
    required this.label,
    required this.background,
    required this.textColor,
  });

  final String label;
  final Color background;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(
          color: colors.cardBorder.withValues(alpha: 0.35),
          width: 1.w,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        child: Text(
          label,
          style: FontPalette.base600(11, color: textColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

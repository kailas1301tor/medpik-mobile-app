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
    final countLabel = orderCardCountLabel(order);
    final showTotal =
        orderStatusShowsTotal(order.status) &&
        order.hasKnownAmount &&
        order.amount > 0;

    return Row(
      children: [
        if (countLabel.isNotEmpty)
          _FooterPill(
            icon: Icons.inventory_2_outlined,
            label: countLabel,
            background: colors.background.withValues(alpha: 0.7),
            textColor: colors.primaryText,
          ),
        if (order.hasPrescription &&
            !countLabel.toLowerCase().contains('prescription')) ...[
          6.horizontalSpace,
          _FooterPill(
            label: Strings.prescriptionOrder,
            background: colors.primary.withValues(alpha: 0.1),
            textColor: colors.primary,
          ),
        ],
        const Spacer(),
        if (showTotal) ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                Strings.totalLabel,
                style: FontPalette.base400(10, color: colors.secondaryText),
              ),
              2.verticalSpace,
              Text(
                order.amount.toCurrency(decimalDigits: 0),
                style: FontPalette.base700(16, color: colors.primaryText),
              ),
            ],
          ),
          10.horizontalSpace,
        ],
        Container(
          width: 36.r,
          height: 36.r,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.background.withValues(alpha: 0.75),
            shape: BoxShape.circle,
            border: Border.all(
              color: colors.cardBorder.withValues(alpha: 0.4),
              width: 1.w,
            ),
          ),
          child: Icon(
            Icons.chevron_right_rounded,
            size: 22.r,
            color: colors.primaryText,
          ),
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
    this.icon,
  });

  final String label;
  final Color background;
  final Color textColor;
  final IconData? icon;

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
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14.r, color: textColor),
              4.horizontalSpace,
            ],
            Text(
              label,
              style: FontPalette.base600(11, color: textColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

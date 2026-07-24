// lib/src/orders/view/widget/order_tile_footer.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/data/models/order_model.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/utils/common_widgets/common_container.dart';
import 'package:medpik/utils/extensions/num_extensions.dart';
import 'package:medpik/utils/helpers/order_status_helper.dart';

class OrderTileFooter extends StatelessWidget {
  const OrderTileFooter({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final showTotal = orderStatusShowsTotal(order.status) &&
        order.hasKnownAmount &&
        order.amount > 0;

    return Row(
      children: [
        Text(
          orderCardCountLabel(order),
          style: FontPalette.base400(12, color: colors.secondaryText),
        ),
        if (order.hasPrescription) ...[
          8.horizontalSpace,
          CommonContainer(
            padding: EdgeInsets.symmetric(
              horizontal: 8.w,
              vertical: 4.h,
            ),
            borderRadius: 8.r,
            color: colors.primary.withValues(alpha: 0.12),
            child: Text(
              Strings.prescriptionOrder,
              style: FontPalette.base600(11, color: colors.primary),
            ),
          ),
        ],
        const Spacer(),
        if (showTotal)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Strings.totalLabel,
                style: FontPalette.base400(
                  11,
                  color: colors.secondaryText,
                ),
              ),
              2.verticalSpace,
              Text(
                order.amount.toCurrency(decimalDigits: 0),
                style: FontPalette.base700(
                  15,
                  color: colors.primaryText,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

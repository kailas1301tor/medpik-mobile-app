// lib/src/orders/view/widget/order_bill_summary_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/data/models/order_model.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/utils/common_widgets/common_container.dart';
import 'package:medpik/utils/extensions/num_extensions.dart';
import 'package:medpik/utils/helpers/order_status_helper.dart';

class OrderBillSummaryWidget extends StatelessWidget {
  const OrderBillSummaryWidget({
    super.key,
    required this.order,
    this.title,
    this.showContainer = true,
  });

  final OrderModel order;
  final String? title;
  final bool showContainer;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final breakdown = resolveOrderBillBreakdown(order);
    final itemCount = orderItemCount(order);

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title??"",
            style: FontPalette.base700(16, color: colors.primaryText),
          ),
          12.verticalSpace,
        ],
        _SummaryRow(
          label: Strings.itemTotalWithCount(itemCount),
          value: breakdown.itemTotal.toCurrency(decimalDigits: 0),
        ),
        8.verticalSpace,
        _SummaryRow(
          label: Strings.deliveryCharges,
          value: breakdown.deliveryCharges.toCurrency(decimalDigits: 0),
        ),
        if (breakdown.discountAmount > 0) ...[
          8.verticalSpace,
          _SummaryRow(
            label: _discountLabel(breakdown),
            value: '−${breakdown.discountAmount.toCurrency(decimalDigits: 0)}',
            valueColor: ColorPalette.successColor,
          ),
        ],
        if (breakdown.tax > 0) ...[
          8.verticalSpace,
          _SummaryRow(
            label: Strings.tax,
            value: breakdown.tax.toCurrency(decimalDigits: 0),
          ),
        ],
        if (breakdown.packagingCharges > 0) ...[
          8.verticalSpace,
          _SummaryRow(
            label: Strings.packagingCharges,
            value: breakdown.packagingCharges.toCurrency(decimalDigits: 0),
          ),
        ],
        12.verticalSpace,
        _DashedDivider(),
        12.verticalSpace,
        Row(
          children: [
            Text(
              Strings.grandTotal,
              style: FontPalette.base700(15, color: colors.primaryText),
            ),
            const Spacer(),
            Text(
              breakdown.grandTotal.toCurrency(decimalDigits: 0),
              style: FontPalette.base700(18, color: colors.primaryText),
            ),
          ],
        ),
      ],
    );

    if (!showContainer) return content;

    return CommonContainer(
      padding: EdgeInsets.all(16.r),
      borderRadius: 16.r,
      color: colors.surface,
      child: content,
    );
  }

  String _discountLabel(OrderBillBreakdown breakdown) {
    final coupon = breakdown.appliedOfferDetail?.couponCode.trim() ?? '';
    if (coupon.isNotEmpty) return Strings.couponSavings(coupon);
    return Strings.discount;
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: FontPalette.base400(14, color: colors.secondaryText),
          ),
        ),
        Text(
          value,
          style: FontPalette.base500(
            14,
            color: valueColor ?? colors.primaryText,
          ),
        ),
      ],
    );
  }
}

class _DashedDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashWidth = 6.w;
        final dashCount = (constraints.maxWidth / (dashWidth * 2)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            dashCount,
            (_) => Container(
              width: dashWidth,
              height: 1.h,
              color: ColorPalette.orderBillDivider,
            ),
          ),
        );
      },
    );
  }
}

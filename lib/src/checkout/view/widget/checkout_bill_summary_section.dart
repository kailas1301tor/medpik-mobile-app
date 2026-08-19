// lib/src/checkout/view/widget/checkout_bill_summary_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medpik/res/constants/medpik_svg_assets.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/checkout/view/widget/checkout_section_card.dart';

class CheckoutBillSummarySection extends StatelessWidget {
  const CheckoutBillSummarySection({super.key, required this.itemCount});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return CheckoutSectionCard(
      title: Strings.orderSummary,
      titleIcon: Icons.receipt_long_rounded,
      child: Column(
        children: [
          _BillRow(
            label: Strings.itemTotalWithCount(itemCount),
            value: Strings.totalAmountSharedAfterReview,
          ),
          10.verticalSpace,
          _BillRow(
            label: Strings.estimatedDelivery,
            value: Strings.estimatedDeliveryAfterBillApproval,
            leading: SvgPicture.asset(
              MedpikSvgAssets.calendar,
              width: 16.r,
              height: 16.r,
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(colors.primary, BlendMode.srcIn),
            ),
          ),
          12.verticalSpace,
          Divider(height: 1.h, color: colors.divider.withValues(alpha: 0.7)),
          12.verticalSpace,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  Strings.grandTotal,
                  style: FontPalette.base700(15, color: colors.primaryText),
                ),
              ),
              12.horizontalSpace,
              Flexible(
                child: Text(
                  Strings.totalAmountSharedAfterReview,
                  textAlign: TextAlign.right,
                  style: FontPalette.base700(15, color: colors.primary),
                ),
              ),
            ],
          ),
          8.verticalSpace,
          Text(
            Strings.cartPricingDisclaimer,
            style: FontPalette.base400(11, color: colors.secondaryText),
          ),
        ],
      ),
    );
  }
}

class _BillRow extends StatelessWidget {
  const _BillRow({required this.label, required this.value, this.leading});

  final String label;
  final String value;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leading != null) ...[
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: leading,
          ),
          8.horizontalSpace,
        ],
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: FontPalette.base400(13, color: colors.secondaryText),
          ),
        ),
        8.horizontalSpace,
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: FontPalette.base500(13, color: colors.primaryText),
          ),
        ),
      ],
    );
  }
}

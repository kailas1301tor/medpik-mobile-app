// lib/src/cart/view/widget/cart_order_summary_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tsuite/res/constants/medpik_svg_assets.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';

class CartOrderSummarySection extends StatelessWidget {
  const CartOrderSummarySection({super.key, required this.itemCount});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.orderSummary,
          style: FontPalette.base700(16, color: colors.primaryText),
        ),
        12.verticalSpace,
        CommonContainer(
          padding: EdgeInsets.all(16.r),
          borderRadius: 16.r,
          color: colors.surface,
          child: Column(
            children: [
              _SummaryRow(
                label: Strings.itemTotalWithCount(itemCount),
                value: Strings.totalAmountSharedAfterReview,
              ),
              8.verticalSpace,
              _SummaryRow(
                label: Strings.estimatedDelivery,
                value: Strings.estimatedDeliveryAfterBillApproval,
                leading: SvgPicture.asset(
                  MedpikSvgAssets.calendar,
                  width: 16.r,
                  height: 16.r,
                  fit: BoxFit.contain,
                ),
              ),
              12.verticalSpace,
              const _DashedDivider(),
              12.verticalSpace,
              Row(
                children: [
                  Text(
                    Strings.grandTotal,
                    style: FontPalette.base700(15, color: colors.primaryText),
                  ),
                  const Spacer(),
                  Text(
                    Strings.totalAmountSharedAfterReview,
                    style: FontPalette.base700(15, color: colors.primaryText),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.leading,
  });

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
          leading!,
          8.horizontalSpace,
        ],
        Expanded(
          child: Text(
            label,
            style: FontPalette.base400(14, color: colors.secondaryText),
          ),
        ),
        8.horizontalSpace,
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: FontPalette.base500(14, color: colors.primaryText),
          ),
        ),
      ],
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

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

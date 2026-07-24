// lib/src/orders/view/widget/order_review_bill_actions.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/utils/common_widgets/common_sticky_bottom_bar.dart';
import 'package:medpik/utils/common_widgets/primary_button.dart';

class OrderReviewBillActions extends StatelessWidget {
  const OrderReviewBillActions({
    super.key,
    required this.isAcceptLoading,
    required this.isRejectLoading,
    required this.onReject,
    required this.onAccept,
  });

  final bool isAcceptLoading;
  final bool isRejectLoading;
  final VoidCallback onReject;
  final VoidCallback onAccept;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final isAnyLoading = isAcceptLoading || isRejectLoading;

    return CommonStickyBottomBar(
      child: Row(
        children: [
          Expanded(
            child: PrimaryButton(
              text: Strings.rejectBill,
              height: 48.h,
              backgroundColor: colors.surface,
              textColor: ColorPalette.orderRejectButtonBorder,
              borderSide: BorderSide(
                color: ColorPalette.orderRejectButtonBorder,
                width: 1.5.w,
              ),
              isLoading: isRejectLoading,
              onPressed: isAnyLoading ? null : onReject,
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: PrimaryButton(
              text: Strings.acceptBill,
              height: 48.h,
              isLoading: isAcceptLoading,
              onPressed: isAnyLoading ? null : onAccept,
            ),
          ),
        ],
      ),
    );
  }
}

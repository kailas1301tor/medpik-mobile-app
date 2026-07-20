// lib/src/checkout/view/widget/checkout_place_order_footer.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/utils/common_widgets/primary_button.dart';

class CheckoutPlaceOrderFooter extends StatelessWidget {
  const CheckoutPlaceOrderFooter({
    super.key,
    required this.isLoading,
    required this.isEnabled,
    required this.onPlaceOrder,
  });

  final bool isLoading;
  final bool isEnabled;
  final VoidCallback onPlaceOrder;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return ColoredBox(
      color: colors.surface,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: colors.divider)),
          boxShadow: [
            BoxShadow(
              color: ColorPalette.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: Offset(0, -4.h),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h),
            child: PrimaryButton(
              text: Strings.placeMedicineCartOrder,
              height: 48,
              isLoading: isLoading,
              onPressed: isEnabled && !isLoading ? onPlaceOrder : null,
            ),
          ),
        ),
      ),
    );
  }
}

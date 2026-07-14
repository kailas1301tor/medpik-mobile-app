// lib/src/cart/view/widget/cart_success_content.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/cart/notifier/cart_notifier.dart';
import 'package:tsuite/src/main/notifier/main_shell_notifier.dart';
import 'package:tsuite/utils/common_widgets/common_success_lottie.dart';
import 'package:tsuite/utils/common_widgets/primary_button.dart';

class CartSuccessContent extends ConsumerWidget {
  const CartSuccessContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final orderId = ref.watch(
      cartNotifierProvider.select((s) => s.submittedOrderId),
    );
    final cartNotifier = ref.read(cartNotifierProvider.notifier);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CommonSuccessLottie(),
          8.verticalSpace,
          Text(
            Strings.orderSubmittedSuccessTitle,
            textAlign: TextAlign.center,
            style: FontPalette.base700(20, color: colors.primaryText),
          ),
          12.verticalSpace,
          Text(
            Strings.orderSubmittedSuccessMessage,
            textAlign: TextAlign.center,
            style: FontPalette.base400(14, color: colors.secondaryText),
          ),
          if (orderId != null) ...[
            8.verticalSpace,
            Text(
              '${Strings.orderIdLabel}: $orderId',
              style: FontPalette.base500(13, color: colors.primary),
            ),
          ],
          32.verticalSpace,
          PrimaryButton(
            text: Strings.viewOrders,
            onPressed: () {
              cartNotifier.resetSubmission();
              ref.read(mainShellNotifierProvider.notifier).setTab(1);
            },
          ),
          12.verticalSpace,
          TextButton(
            onPressed: () {
              cartNotifier.resetSubmission();
              ref.read(mainShellNotifierProvider.notifier).setTab(0);
            },
            child: Text(
              Strings.continueShopping,
              style: FontPalette.base600(14, color: colors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

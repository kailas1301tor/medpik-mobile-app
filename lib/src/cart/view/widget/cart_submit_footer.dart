// lib/src/cart/view/widget/cart_submit_footer.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/src/cart/notifier/cart_notifier.dart';
import 'package:medpik/utils/helpers/shell_insets_helper.dart';
import 'package:medpik/utils/common_widgets/primary_button.dart';
import 'package:medpik/utils/routes/route_constants.dart';
import 'package:tuple/tuple.dart';

/// Checkout CTA pinned below the cart list, above the main-shell floating nav.
class CartSubmitFooter extends ConsumerWidget {
  const CartSubmitFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final footerData = ref.watch(
      cartNotifierProvider.select((s) => Tuple2(s.loaderState, s.items.length)),
    );
    final loaderState = footerData.item1;
    final itemCount = footerData.item2;
    final isScreenLoading = loaderState == LoaderState.loading;

    return ColoredBox(
      color: colors.background,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: colors.divider)),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20.w,
            12.h,
            20.w,
            dockedFooterInset(context, gap: 16),
          ),
          child: PrimaryButton(
            text: Strings.proceedToCheckout,
            height: 48.h,
            isLoading: isScreenLoading,
            onPressed: isScreenLoading || itemCount == 0
                ? null
                : () {
                    Navigator.pushNamed(
                      context,
                      RouteConstants.routeCheckoutScreen,
                    );
                  },
          ),
        ),
      ),
    );
  }
}

// lib/src/cart/view/widget/cart_submit_footer.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/src/cart/notifier/cart_notifier.dart';
import 'package:tsuite/src/main/view/widget/bottom_navigation_section.dart';
import 'package:tsuite/utils/common_widgets/primary_button.dart';
import 'package:tsuite/utils/routes/route_constants.dart';
import 'package:tuple/tuple.dart';

/// Checkout CTA pinned below the cart list, above the main-shell floating nav.
class CartSubmitFooter extends ConsumerWidget {
  const CartSubmitFooter({super.key});

  static const double _buttonHeight = 48;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final footerData = ref.watch(
      cartNotifierProvider.select(
        (s) => Tuple3(s.loaderState, s.isMutating, s.items.length),
      ),
    );
    final loaderState = footerData.item1;
    final isMutating = footerData.item2;
    final itemCount = footerData.item3;
    final isLoading = loaderState == LoaderState.loading || isMutating;

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
            BottomNavigationSection.dockedFooterInset(context, gap: 16),
          ),
          child: PrimaryButton(
            text: Strings.proceedToCheckout,
            height: _buttonHeight,
            isLoading: isLoading,
            onPressed: isLoading || itemCount == 0
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

// lib/src/checkout/view/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/data/models/address_model.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/src/address/model/address_book_args.dart';
import 'package:tsuite/src/cart/notifier/cart_notifier.dart';
import 'package:tsuite/src/checkout/notifier/checkout_notifier.dart';
import 'package:tsuite/src/checkout/view/widget/checkout_address_card.dart';
import 'package:tsuite/src/checkout/view/widget/checkout_order_summary.dart';
import 'package:tsuite/src/orders/view/widget/order_sticky_bottom_bar.dart';
import 'package:tsuite/utils/common_widgets/common_app_bar.dart';
import 'package:tsuite/utils/common_widgets/common_empty_state.dart';
import 'package:tsuite/utils/common_widgets/common_loader.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';
import 'package:tsuite/utils/common_widgets/primary_button.dart';
import 'package:tsuite/utils/routes/route_constants.dart';
import 'package:tuple/tuple.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final prepare = ref.watch(
      checkoutNotifierProvider.select(
        (s) => Tuple2(s.loaderState, s.errorMessage),
      ),
    );
    final loaderState = prepare.item1;
    final errorMessage = prepare.item2;
    final address = ref.watch(
      checkoutNotifierProvider.select((s) => s.selectedAddress),
    );
    final isPlacingOrder = ref.watch(
      checkoutNotifierProvider.select((s) => s.isPlacingOrder),
    );
    final cartItems = ref.watch(cartNotifierProvider.select((s) => s.items));
    final notifier = ref.read(checkoutNotifierProvider.notifier);

    if (loaderState == LoaderState.loading) {
      return const CommonScaffold(
        appBar: CommonAppBar(title: Strings.checkout),
        body: Center(child: CommonLoader()),
      );
    }

    if (loaderState == LoaderState.error ||
        loaderState == LoaderState.noData) {
      return CommonScaffold(
        appBar: const CommonAppBar(title: Strings.checkout),
        body: CommonEmptyState(
          title: Strings.errorTitle,
          message: errorMessage ?? Strings.cartEmptyMessage,
          buttonText: Strings.goBackButton,
          onPressed: () => Navigator.pop(context),
        ),
      );
    }

    if (loaderState == LoaderState.networkError ||
        loaderState == LoaderState.serverError) {
      return CommonScaffold(
        appBar: const CommonAppBar(title: Strings.checkout),
        body: CommonEmptyState(
          title: Strings.errorTitle,
          message: errorMessage ?? Strings.errorDescription,
          buttonText: Strings.refresh,
          onPressed: notifier.prepareCheckout,
        ),
      );
    }

    return CommonScaffold(
      appBar: const CommonAppBar(title: Strings.checkout),
      backgroundColor: colors.background,
      body: IgnorePointer(
        ignoring: isPlacingOrder,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                children: [
                  CheckoutAddressCard(
                    address: address,
                    onChangeAddress: () async {
                      final selected =
                          await Navigator.pushNamed<AddressModel>(
                        context,
                        RouteConstants.routeAddressBookScreen,
                        arguments: AddressBookArgs(
                          selectMode: true,
                          selectedAddressId: address?.id,
                        ),
                      );
                      if (selected != null) {
                        notifier.selectAddress(selected);
                      } else if (context.mounted) {
                        await notifier.refreshSelectedAddress();
                      }
                    },
                  ),
                  24.verticalSpace,
                  CheckoutOrderSummary(cartItems: cartItems),
                ],
              ),
            ),
            OrderStickyBottomBar(
              child: PrimaryButton(
                text: Strings.placeOrder,
                height: 48.h,
                isLoading: isPlacingOrder,
                onPressed: address == null
                    ? null
                    : () async {
                        final orderId = await notifier.placeOrder();
                        if (orderId != null && context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            RouteConstants.routeConfirmationScreen,
                            (route) =>
                                route.settings.name ==
                                RouteConstants.mainScreen,
                            arguments: orderId,
                          );
                        }
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

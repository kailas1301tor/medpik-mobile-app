// lib/src/checkout/view/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/data/models/address_book_args.dart';
import 'package:medpik/data/models/address_model.dart';
import 'package:medpik/data/models/order_confirmation_args.dart';
import 'package:medpik/providers/cart_providers.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/src/checkout/notifier/checkout_notifier.dart';
import 'package:medpik/src/checkout/view/widget/checkout_address_card.dart';
import 'package:medpik/src/checkout/view/widget/checkout_bill_summary_section.dart';
import 'package:medpik/src/checkout/view/widget/checkout_order_summary.dart';
import 'package:medpik/src/checkout/view/widget/checkout_pharmacist_instructions_card.dart';
import 'package:medpik/src/checkout/view/widget/checkout_place_order_footer.dart';
import 'package:medpik/src/checkout/view/widget/checkout_shimmer_widget.dart';
import 'package:medpik/utils/common_widgets/cart_pricing_banner.dart';
import 'package:medpik/utils/common_widgets/common_app_bar.dart';
import 'package:medpik/utils/common_widgets/common_scaffold.dart';
import 'package:medpik/utils/common_widgets/common_switch_state.dart';
import 'package:medpik/utils/routes/route_constants.dart';
import 'package:tuple/tuple.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final checkoutData = ref.watch(
      checkoutNotifierProvider.select(
        (s) => Tuple4(
          s.loaderState,
          s.errorMessage,
          s.selectedAddress,
          s.isPlacingOrder,
        ),
      ),
    );
    final loaderState = checkoutData.item1;
    final errorMessage = checkoutData.item2;
    final address = checkoutData.item3;
    final isPlacingOrder = checkoutData.item4;
    final cartItems = ref.watch(cartNotifierProvider.select((s) => s.items));
    final notifier = ref.read(checkoutNotifierProvider.notifier);
    final itemCount = cartItems.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );

    return CommonScaffold(
      appBar: const CommonAppBar(title: Strings.medicineCartCheckoutTitle),
      backgroundColor: colors.background,
      safeAreaBottom: false,
      body: CommonSwitchState(
        loaderState: loaderState,
        reload: notifier.prepareCheckout,
        loader: CheckoutShimmerWidget(itemCount: itemCount),
        errorMessage: errorMessage,
        buttonText: loaderState == LoaderState.noData
            ? Strings.goBackButton
            : Strings.refresh,
        customButtonFunction: loaderState == LoaderState.noData
            ? () => Navigator.pop(context)
            : notifier.prepareCheckout,
        emptyScreenTitle: Strings.errorTitle,
        emptyScreenDescription: errorMessage ?? Strings.cartEmptyMessage,
        child: IgnorePointer(
          ignoring: isPlacingOrder,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
                  children: [
                    const CartPricingBanner(showBorder: false),
                    16.verticalSpace,
                    const CheckoutPharmacistInstructionsCard(),
                    16.verticalSpace,
                    CheckoutAddressCard(
                      address: address,
                      onChangeAddress: () =>
                          _changeAddress(context, ref, notifier),
                    ),
                    16.verticalSpace,
                    CheckoutOrderSummary(cartItems: cartItems),
                    16.verticalSpace,
                    CheckoutBillSummarySection(itemCount: itemCount),
                  ],
                ),
              ),
              CheckoutPlaceOrderFooter(
                isLoading: isPlacingOrder,
                isEnabled: address != null,
                onPlaceOrder: () => _placeOrder(context, ref, notifier),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _changeAddress(
    BuildContext context,
    WidgetRef ref,
    CheckoutNotifier notifier,
  ) async {
    final address = ref.read(
      checkoutNotifierProvider.select((s) => s.selectedAddress),
    );
    final selected = await Navigator.pushNamed<AddressModel>(
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
  }

  Future<void> _placeOrder(
    BuildContext context,
    WidgetRef ref,
    CheckoutNotifier notifier,
  ) async {
    final orderId = await notifier.placeMedicineCartOrder();
    if (orderId != null && context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteConstants.routeConfirmationScreen,
        (route) => route.settings.name == RouteConstants.mainScreen,
        arguments: OrderConfirmationArgs(
          orderId: orderId,
          source: OrderSubmissionSource.medicineCart,
        ),
      );
    }
  }
}

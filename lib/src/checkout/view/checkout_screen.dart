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
import 'package:tsuite/src/cart/view/widget/cart_pricing_banner.dart';
import 'package:tsuite/src/checkout/model/order_confirmation_args.dart';
import 'package:tsuite/services/cart_facade_service.dart';
import 'package:tsuite/src/checkout/notifier/checkout_notifier.dart';
import 'package:tsuite/src/checkout/view/widget/checkout_address_card.dart';
import 'package:tsuite/src/checkout/view/widget/checkout_bill_summary_section.dart';
import 'package:tsuite/src/checkout/view/widget/checkout_order_summary.dart';
import 'package:tsuite/src/checkout/view/widget/checkout_pharmacist_instructions_card.dart';
import 'package:tsuite/src/checkout/view/widget/checkout_place_order_footer.dart';
import 'package:tsuite/utils/common_widgets/common_app_bar.dart';
import 'package:tsuite/utils/common_widgets/common_empty_state.dart';
import 'package:tsuite/src/checkout/view/widget/checkout_shimmer_widget.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';
import 'package:tsuite/utils/routes/route_constants.dart';
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
    final cartItems = ref.watch(cartItemsProvider);
    final isCartMutating = ref.watch(
      cartNotifierProvider.select((s) => s.isMutating),
    );
    final notifier = ref.read(checkoutNotifierProvider.notifier);
    final itemCount = cartItems.fold<int>(0, (sum, item) => sum + item.quantity);

    if (loaderState == LoaderState.loading) {
      return CommonScaffold(
        appBar: const CommonAppBar(title: Strings.medicineCartCheckoutTitle),
        backgroundColor: colors.background,
        safeAreaBottom: false,
        body: const CheckoutShimmerWidget(),
      );
    }

    if (loaderState == LoaderState.error ||
        loaderState == LoaderState.noData) {
      return CommonScaffold(
        appBar: const CommonAppBar(title: Strings.medicineCartCheckoutTitle),
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
        appBar: const CommonAppBar(title: Strings.medicineCartCheckoutTitle),
        body: CommonEmptyState(
          title: Strings.errorTitle,
          message: errorMessage ?? Strings.errorDescription,
          buttonText: Strings.refresh,
          onPressed: notifier.prepareCheckout,
        ),
      );
    }

    return CommonScaffold(
      appBar: const CommonAppBar(title: Strings.medicineCartCheckoutTitle),
      backgroundColor: colors.background,
      safeAreaBottom: false,
      body: IgnorePointer(
        ignoring: isPlacingOrder || isCartMutating,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
                children: [
                  const CartPricingBanner(),
                  20.verticalSpace,
                  const CheckoutPharmacistInstructionsCard(),
                  20.verticalSpace,
                  CheckoutAddressCard(
                    address: address,
                    onChangeAddress: () => _changeAddress(context, ref, notifier),
                  ),
                  20.verticalSpace,
                  CheckoutOrderSummary(cartItems: cartItems),
                  20.verticalSpace,
                  CheckoutBillSummarySection(itemCount: itemCount),
                ],
              ),
            ),
            CheckoutPlaceOrderFooter(
              isLoading: isPlacingOrder,
              isEnabled: address != null && !isCartMutating,
              onPlaceOrder: () => _placeOrder(context, ref, notifier),
            ),
          ],
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

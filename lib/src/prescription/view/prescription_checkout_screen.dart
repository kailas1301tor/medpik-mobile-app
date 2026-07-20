// lib/src/prescription/view/prescription_checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/data/models/address_model.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/src/address/model/address_book_args.dart';
import 'package:tsuite/src/checkout/model/order_confirmation_args.dart';
import 'package:tsuite/utils/common_widgets/common_sticky_bottom_bar.dart';
import 'package:tsuite/src/prescription/notifier/prescription_checkout_notifier.dart';
import 'package:tsuite/src/prescription/notifier/prescription_notifier.dart';
import 'package:tsuite/src/prescription/view/widget/prescription_checkout_address_card.dart';
import 'package:tsuite/src/prescription/view/widget/prescription_checkout_order_summary.dart';
import 'package:tsuite/src/prescription/view/widget/prescription_checkout_shimmer_widget.dart';
import 'package:tsuite/utils/common_widgets/common_app_bar.dart';
import 'package:tsuite/utils/common_widgets/common_empty_state.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';
import 'package:tsuite/utils/common_widgets/primary_button.dart';
import 'package:tsuite/utils/routes/route_constants.dart';
import 'package:tuple/tuple.dart';

class PrescriptionCheckoutScreen extends ConsumerWidget {
  const PrescriptionCheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final checkoutData = ref.watch(
      prescriptionCheckoutNotifierProvider.select(
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
    final draft = ref.watch(
      prescriptionNotifierProvider.select((s) => s.draft),
    );
    final notifier = ref.read(prescriptionCheckoutNotifierProvider.notifier);

    if (loaderState == LoaderState.loading) {
      return const CommonScaffold(
        appBar: CommonAppBar(title: Strings.prescriptionOrderCheckoutTitle),
        body: PrescriptionCheckoutShimmerWidget(),
      );
    }

    if (loaderState == LoaderState.error ||
        loaderState == LoaderState.noData) {
      return CommonScaffold(
        appBar: const CommonAppBar(title: Strings.prescriptionOrderCheckoutTitle),
        body: CommonEmptyState(
          title: Strings.errorTitle,
          message: errorMessage ?? Strings.attachPrescriptionToContinue,
          buttonText: Strings.goBackButton,
          onPressed: () => Navigator.pop(context),
        ),
      );
    }

    if (loaderState == LoaderState.networkError ||
        loaderState == LoaderState.serverError) {
      return CommonScaffold(
        appBar: const CommonAppBar(title: Strings.prescriptionOrderCheckoutTitle),
        body: CommonEmptyState(
          title: Strings.errorTitle,
          message: errorMessage ?? Strings.errorDescription,
          buttonText: Strings.refresh,
          onPressed: notifier.prepareCheckout,
        ),
      );
    }

    return CommonScaffold(
      appBar: const CommonAppBar(title: Strings.prescriptionOrderCheckoutTitle),
      backgroundColor: colors.background,
      body: IgnorePointer(
        ignoring: isPlacingOrder,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                children: [
                  PrescriptionCheckoutAddressCard(
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
                  PrescriptionCheckoutOrderSummary(
                    filePaths: draft?.filePaths ?? const [],
                    products: draft?.selectedProducts ?? const [],
                  ),
                ],
              ),
            ),
            CommonStickyBottomBar(
              child: PrimaryButton(
                text: Strings.submitPrescriptionOrder,
                height: 48.h,
                isLoading: isPlacingOrder,
                onPressed: address == null
                    ? null
                    : () async {
                        final orderId =
                            await notifier.placePrescriptionOrder();
                        if (orderId != null && context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            RouteConstants.routeConfirmationScreen,
                            (route) =>
                                route.settings.name ==
                                RouteConstants.mainScreen,
                            arguments: OrderConfirmationArgs(
                              orderId: orderId,
                              source: OrderSubmissionSource.prescription,
                            ),
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

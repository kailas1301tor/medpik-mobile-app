// lib/src/checkout/notifier/checkout_notifier.dart
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/data/models/address_model.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/services/address_book_service.dart';
import 'package:tsuite/services/cart_facade_service.dart';
import 'package:tsuite/services/checkout_flow_service.dart';
import 'package:tsuite/src/address/notifier/address_notifier.dart';
import 'package:tsuite/src/cart/notifier/cart_notifier.dart';
import 'package:tsuite/src/checkout/state/checkout_state.dart';
import 'package:tsuite/utils/common_widgets/custom_toast.dart';
import 'package:tsuite/utils/helpers/address_resolution_helper.dart';
import 'package:tsuite/utils/helpers/api_error_handler.dart';

part 'checkout_notifier.g.dart';

@Riverpod(keepAlive: false)
class CheckoutNotifier extends _$CheckoutNotifier {
  late final TextEditingController pharmacistInstructionsController;

  @override
  CheckoutState build() {
    pharmacistInstructionsController = TextEditingController();
    ref.onDispose(pharmacistInstructionsController.dispose);
    Future.microtask(prepareCheckout);
    return const CheckoutState(loaderState: LoaderState.loading);
  }

  Future<void> prepareCheckout() async {
    final cartItems = ref.read(cartItemsProvider);
    final addressBook = ref.read(addressBookServiceProvider);

    await addressBook.fetchAddresses();
    final addressState = ref.read(addressNotifierProvider);
    if (addressState.loaderState == LoaderState.networkError ||
        addressState.loaderState == LoaderState.serverError ||
        addressState.loaderState == LoaderState.error) {
      state = state.copyWith(
        loaderState: addressState.loaderState,
        errorMessage: Strings.errorDescription,
        isPlacingOrder: false,
      );
      return;
    }

    final addresses = addressBook.addresses;

    if (cartItems.isEmpty) {
      state = state.copyWith(
        loaderState: LoaderState.error,
        errorMessage: Strings.cartEmptyMessage,
      );
      return;
    }

    final subtotal = cartItems.fold<double>(0, (sum, i) => sum + i.lineTotal);

    state = state.copyWith(
      loaderState: LoaderState.loaded,
      selectedAddress: resolveSelectedAddress(
        addresses,
        current: state.selectedAddress,
      ),
      pharmacistInstructions: state.pharmacistInstructions,
      payableTotal: subtotal,
      isPlacingOrder: false,
    );
    pharmacistInstructionsController.text = state.pharmacistInstructions;
  }

  Future<void> refreshSelectedAddress() async {
    final addressBook = ref.read(addressBookServiceProvider);
    await addressBook.fetchAddresses();
    state = state.copyWith(
      selectedAddress: resolveSelectedAddress(
        addressBook.addresses,
        current: state.selectedAddress,
      ),
    );
  }

  void selectAddress(AddressModel address) {
    state = state.copyWith(selectedAddress: address);
  }

  void savePharmacistInstructions(String value) {
    final trimmed = value.trim();
    pharmacistInstructionsController.text = trimmed;
    state = state.copyWith(pharmacistInstructions: trimmed);
  }

  Future<String?> placeMedicineCartOrder() async {
    if (state.isPlacingOrder) return null;

    final cartItems = ref.read(cartItemsProvider);
    final address = state.selectedAddress;

    if (address == null) {
      showCustomToast(message: Strings.addAddressToContinue, isSuccess: false);
      return null;
    }

    if (cartItems.isEmpty) {
      showCustomToast(message: Strings.cartEmptyMessage, isSuccess: false);
      return null;
    }

    state = state.copyWith(isPlacingOrder: true);

    final checkoutFlow = ref.read(checkoutFlowServiceProvider);
    return await checkoutFlow
        .placeOrder(
          addressId: address.id,
          deliveryInstructions: state.pharmacistInstructions,
        )
        .then((result) async {
          if (result.error != null) {
            final loaderState = handleResponseError(result.error!.key);
            debugPrint("🔴 PLACE ORDER ERROR: ${result.error!.message}");
            state = state.copyWith(
              isPlacingOrder: false,
              loaderState: loaderState,
              errorMessage: result.error!.message ?? Strings.somethingWentWrong,
            );
            showCustomToast(
              message: result.error!.message ?? Strings.somethingWentWrong,
              isSuccess: false,
            );
            return null;
          }

          final orderId = result.orderId ?? Strings.emDash;
          debugPrint("🟢 ORDER PLACED: $orderId");
          await ref
              .read(cartNotifierProvider.notifier)
              .fetchCart(showLoader: false);
          state = state.copyWith(
            isPlacingOrder: false,
            placedOrderId: orderId,
          );
          return orderId;
        })
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED PLACE ORDER ERROR: $error");
          state = state.copyWith(isPlacingOrder: false);
          showCustomToast(
            message: Strings.somethingWentWrong,
            isSuccess: false,
          );
          return null;
        });
  }
}

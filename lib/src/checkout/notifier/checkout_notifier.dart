// lib/src/checkout/notifier/checkout_notifier.dart
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/data/models/address_model.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/services/repo_di.dart';
import 'package:tsuite/src/address/notifier/address_notifier.dart';
import 'package:tsuite/src/cart/notifier/cart_notifier.dart';
import 'package:tsuite/src/checkout/repo/checkout_repository.dart';
import 'package:tsuite/src/checkout/state/checkout_state.dart';
import 'package:tsuite/src/prescription/notifier/prescription_notifier.dart';
import 'package:tsuite/utils/common_widgets/custom_toast.dart';
import 'package:tsuite/utils/helpers/api_error_handler.dart';

part 'checkout_notifier.g.dart';

@Riverpod(keepAlive: false)
class CheckoutNotifier extends _$CheckoutNotifier {
  late CheckoutRepo checkoutRepo;

  @override
  CheckoutState build() {
    checkoutRepo = ref.read(checkoutRepositoryProvider);
    Future.microtask(prepareCheckout);
    return const CheckoutState(loaderState: LoaderState.loading);
  }

  Future<void> prepareCheckout() async {
    final cartItems = ref.read(cartNotifierProvider).items;
    final prescription = ref.read(prescriptionNotifierProvider).draft;
    final addresses = ref.read(addressNotifierProvider).addresses;

    if (cartItems.isEmpty && prescription == null) {
      state = state.copyWith(
        loaderState: LoaderState.error,
        errorMessage: Strings.cartAndPrescriptionEmpty,
      );
      return;
    }

    final subtotal = cartItems.fold<double>(0, (sum, i) => sum + i.lineTotal);
    AddressModel? selected;
    for (final address in addresses) {
      if (address.isDefault) {
        selected = address;
        break;
      }
    }
    selected ??= addresses.isNotEmpty ? addresses.first : null;

    state = state.copyWith(
      loaderState: LoaderState.loaded,
      selectedAddress: selected,
      payableTotal: subtotal,
      hasPrescription: prescription != null,
    );
  }

  Future<String?> placeOrder() async {
    final cartItems = ref.read(cartNotifierProvider).items;
    final address = state.selectedAddress;

    if (address == null) {
      showCustomToast(message: Strings.addAddressToContinue, isSuccess: false);
      return null;
    }

    if (cartItems.isEmpty && !state.hasPrescription) {
      showCustomToast(
        message: Strings.cartAndPrescriptionEmpty,
        isSuccess: false,
      );
      return null;
    }

    state = state.copyWith(loaderState: LoaderState.loading);

    return await checkoutRepo
        .placeOrder(
          items: cartItems,
          address: address,
          hasPrescription: state.hasPrescription,
          amount: state.payableTotal,
        )
        .fold(
          (error) {
            final loaderState = handleResponseError(error.key);
            debugPrint("🔴 PLACE ORDER ERROR: ${error.message}");
            state = state.copyWith(loaderState: loaderState);
            return null;
          },
          (order) async {
            debugPrint("🟢 ORDER PLACED: ${order.id}");
            ref.read(cartNotifierProvider.notifier).clearCart();
            await ref.read(prescriptionNotifierProvider.notifier).loadDraft();
            state = state.copyWith(
              loaderState: LoaderState.loaded,
              placedOrderId: order.id,
            );
            return order.id;
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED PLACE ORDER ERROR: $error");
          state = state.copyWith(loaderState: LoaderState.error);
          return null;
        });
  }
}
